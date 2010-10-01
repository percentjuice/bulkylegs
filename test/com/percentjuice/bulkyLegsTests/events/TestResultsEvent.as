package com.percentjuice.bulkyLegsTests.events
{
	import com.percentjuice.bulkyLegsTests.vo.TestResultsO;

	import flash.events.Event;

	public class TestResultsEvent extends Event
	{
		public static const RESULTS:String = 'results';
		public var testResultsO:TestResultsO;
		public function TestResultsEvent(testResultsO:TestResultsO)
		{
			super(RESULTS, false, false);
			this.testResultsO=testResultsO;
		}

		/* override clone so the event can be redispatched */
		public override function clone():Event
		{
			return new TestResultsEvent(testResultsO);
		}
	}
}

