using System;
using System.Collections.Concurrent;
using System.Diagnostics;
using System.IO;
using System.Net.WebSockets;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace LethalApeR.UI.Notifications
{
	public sealed class LiveAnnouncementSocket
	{
		private static readonly TimeSpan PingInterval = TimeSpan.FromSeconds(25.0);

		private static readonly TimeSpan DeadAfter = TimeSpan.FromSeconds(70.0);

		private static readonly TimeSpan ConnectTimeout = TimeSpan.FromSeconds(15.0);

		private static readonly TimeSpan StableAfter = TimeSpan.FromSeconds(60.0);

		private const double FirstRetrySeconds = 4.0;

		private const double MaxRetrySeconds = 90.0;

		private const int MaxMessageBytes = 16384;

		private const string Pong = "pong";

		private static readonly byte[] PingFrame = Encoding.ASCII.GetBytes("ping");

		public readonly ConcurrentQueue<string> Inbox = new ConcurrentQueue<string>();

		private readonly Uri _uri;

		private CancellationTokenSource _run;

		private int _connected;

		private long _lastHeardAt;

		private string _lastError;

		private string _abortReason;

		public bool IsConnected => Volatile.Read(ref _connected) == 1;

		public string LastError => Volatile.Read(ref _lastError);

		public LiveAnnouncementSocket(Uri uri)
		{
			_uri = uri;
		}

		public void Start()
		{
			if (_run != null)
			{
				return;
			}
			_run = new CancellationTokenSource();
			CancellationToken token = _run.Token;
			Task.Run(() => RunAsync(token));
		}

		public void Stop()
		{
			CancellationTokenSource run = _run;
			if (run != null)
			{
				_run = null;
				run.Cancel();
			}
		}

		private async Task RunAsync(CancellationToken stop)
		{
			Random random = new Random();
			int failures = 0;
			try
			{
				while (!stop.IsCancellationRequested)
				{
					long openedAt = 0L;
					try
					{
						using (ClientWebSocket ws = new ClientWebSocket())
						{
							ws.Options.KeepAliveInterval = TimeSpan.Zero;
							using (CancellationTokenSource connect = CancellationTokenSource.CreateLinkedTokenSource(stop))
							{
								connect.CancelAfter(ConnectTimeout);
								await ws.ConnectAsync(_uri, connect.Token).ConfigureAwait(false);
							}
							openedAt = Stopwatch.GetTimestamp();
							Interlocked.Exchange(ref _lastHeardAt, openedAt);
							Interlocked.Exchange(ref _connected, 1);
							using (CancellationTokenSource session = CancellationTokenSource.CreateLinkedTokenSource(stop))
							{
								Task pinger = PingLoopAsync(ws, session.Token);
								try
								{
									await ReceiveLoopAsync(ws, session.Token).ConfigureAwait(false);
									Volatile.Write(ref _lastError, "closed by server");
								}
								finally
								{
									session.Cancel();
									try
									{
										await pinger.ConfigureAwait(false);
									}
									catch (Exception)
									{
									}
								}
							}
						}
					}
					catch (Exception ex) when (!stop.IsCancellationRequested)
					{
						Volatile.Write(ref _lastError, Volatile.Read(ref _abortReason) ?? ((ex is OperationCanceledException) ? "connect timed out" : ex.GetBaseException().Message));
					}
					finally
					{
						Interlocked.Exchange(ref _connected, 0);
						Volatile.Write(ref _abortReason, null);
					}
					if (stop.IsCancellationRequested)
					{
						break;
					}
					if (openedAt != 0L && Elapsed(openedAt) > StableAfter)
					{
						failures = 0;
					}
					double delay = Math.Min(FirstRetrySeconds * Math.Pow(2.0, failures++), MaxRetrySeconds) * (0.5 + random.NextDouble());
					await Task.Delay(TimeSpan.FromSeconds(delay), stop).ConfigureAwait(false);
				}
			}
			catch (OperationCanceledException)
			{
			}
		}

		private async Task ReceiveLoopAsync(ClientWebSocket ws, CancellationToken token)
		{
			byte[] buffer = new byte[4096];
			ArraySegment<byte> segment = new ArraySegment<byte>(buffer);
			MemoryStream message = new MemoryStream();
			while (ws.State == WebSocketState.Open)
			{
				WebSocketReceiveResult result = await ws.ReceiveAsync(segment, token).ConfigureAwait(false);
				Interlocked.Exchange(ref _lastHeardAt, Stopwatch.GetTimestamp());
				if (result.MessageType == WebSocketMessageType.Close)
				{
					using (CancellationTokenSource bye = CancellationTokenSource.CreateLinkedTokenSource(token))
					{
						bye.CancelAfter(2000);
						await ws.CloseOutputAsync(WebSocketCloseStatus.NormalClosure, null, bye.Token).ConfigureAwait(false);
					}
					return;
				}
				message.Write(buffer, 0, result.Count);
				if (message.Length > MaxMessageBytes)
				{
					throw new InvalidDataException("Live channel frame over " + MaxMessageBytes + " bytes.");
				}
				if (result.EndOfMessage)
				{
					if (result.MessageType == WebSocketMessageType.Text)
					{
						string text = Encoding.UTF8.GetString(message.GetBuffer(), 0, (int)message.Length);
						if (text != Pong)
						{
							Inbox.Enqueue(text);
						}
					}
					message.SetLength(0L);
				}
			}
		}

		private async Task PingLoopAsync(ClientWebSocket ws, CancellationToken token)
		{
			ArraySegment<byte> ping = new ArraySegment<byte>(PingFrame);
			while (!token.IsCancellationRequested && ws.State == WebSocketState.Open)
			{
				await Task.Delay(PingInterval, token).ConfigureAwait(false);
				if (Elapsed(Interlocked.Read(ref _lastHeardAt)) > DeadAfter)
				{
					Volatile.Write(ref _abortReason, "no reply for " + (int)DeadAfter.TotalSeconds + " s");
					ws.Abort();
					break;
				}
				await ws.SendAsync(ping, WebSocketMessageType.Text, endOfMessage: true, token).ConfigureAwait(false);
			}
		}

		private static TimeSpan Elapsed(long since)
		{
			return TimeSpan.FromSeconds((double)(Stopwatch.GetTimestamp() - since) / (double)Stopwatch.Frequency);
		}
	}
}
