namespace LethalApeR.Monetization
{
	public readonly struct AtmResult
	{
		public readonly AtmOutcome Outcome;

		public readonly string Sku;

		public readonly int GoldGranted;

		public readonly int NewBalance;

		public readonly string Message;

		public bool Credited => Outcome == AtmOutcome.Success || Outcome == AtmOutcome.Restored;

		public AtmResult(AtmOutcome outcome, string sku, int goldGranted, int newBalance, string message)
		{
			Outcome = outcome;
			Sku = sku;
			GoldGranted = goldGranted;
			NewBalance = newBalance;
			Message = message;
		}
	}
}
