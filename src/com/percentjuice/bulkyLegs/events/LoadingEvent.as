/**
 * @author cStuempges, percentjuice.com.
 * This software is provided 'as-is', without any express or implied
 * warranty.  In no event will the authors be held liable for any damages
 * arising from the use of this software.
 * Permission is granted to anyone to use this software for any purpose,
 * including commercial applications, and to alter it and redistribute it
 * freely, subject to the following restrictions:
 * 1. The origin of this software must not be misrepresented; you must not
 * claim that you wrote the original software. If you use this software
 * in a product, an acknowledgment in the product documentation would be
 * appreciated but is not required.
 * 2. Altered source versions must be plainly marked as such, and must not be
 * misrepresented as being the original software.
 * 3. This notice may not be removed or altered from any source distribution.
 *
 * http://www.opensource.org/licenses/mit-license.php
 */
package com.percentjuice.bulkyLegs.events
{
	import br.com.stimuli.loading.BulkProgressEvent;

	import flash.events.Event;
	import flash.events.ProgressEvent;

	/**
	 * Decorates ProgressEvent||BulkProgressEvent.  Modifies type name.
	 * @author C Stuempges
	 */
	public class LoadingEvent extends ProgressEvent
	{
		/* event types */
		public static const REQUEST_LOADING:String = 'request loading';
		private var decoratedEvent:ProgressEvent;

		public function LoadingEvent(decoratedEvent:ProgressEvent)
		{
			super(REQUEST_LOADING, false, false);
			this.decoratedEvent=decoratedEvent;
		}

		/* override clone so the event can be redispatched */
		override public function clone():Event
		{
			var le:LoadingEvent = new LoadingEvent(decoratedEvent);
			return le as Event;
		}

		/* 'utility function for implementing the toString() method' */
		override public function toString():String
		{
			return String(formatToString("LoadingEvent", "type"));
		}

		public function get bytesTotalCurrent():int
		{
			return (decoratedEvent is BulkProgressEvent) ? (decoratedEvent as BulkProgressEvent).bytesTotalCurrent : undefined;
		}

		public function get itemsLoaded():int
		{
			return (decoratedEvent is BulkProgressEvent) ? (decoratedEvent as BulkProgressEvent).itemsLoaded : undefined;
		}

		public function get itemsTotal():int
		{
			return (decoratedEvent is BulkProgressEvent) ? (decoratedEvent as BulkProgressEvent).itemsTotal : undefined;
		}

		public function get percentLoaded():Number
		{
			return (decoratedEvent is BulkProgressEvent) ? (decoratedEvent as BulkProgressEvent).percentLoaded : undefined;
		}

		public function get ratioLoaded():Number
		{
			return (decoratedEvent is BulkProgressEvent) ? (decoratedEvent as BulkProgressEvent).ratioLoaded : undefined;
		}

		public function get weightPercent():Number
		{
			return (decoratedEvent is BulkProgressEvent) ? (decoratedEvent as BulkProgressEvent).weightPercent : undefined;
		}

		public function get name():String
		{
			return (decoratedEvent is BulkProgressEvent) ? (decoratedEvent as BulkProgressEvent).name : undefined;
		}

	}
}

