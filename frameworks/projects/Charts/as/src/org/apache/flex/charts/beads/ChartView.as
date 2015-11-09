////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "License"); you may not use this file except in compliance with
//  the License.  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////
package org.apache.flex.charts.beads
{
	import org.apache.flex.charts.core.IAxisGroup;
	import org.apache.flex.charts.core.IHorizontalAxisBead;
	import org.apache.flex.charts.core.IVerticalAxisBead;
	import org.apache.flex.core.IBeadLayout;
	import org.apache.flex.core.IBeadView;
	import org.apache.flex.core.IParent;
	import org.apache.flex.core.ISelectionModel;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IViewport;
	import org.apache.flex.core.IViewportModel;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
    import org.apache.flex.geom.Rectangle;
    import org.apache.flex.geom.Size;
	import org.apache.flex.html.beads.ListView;
	import org.apache.flex.html.beads.models.ViewportModel;
	import org.apache.flex.html.supportClasses.Viewport;
	import org.apache.flex.utils.CSSContainerUtils;
	
	public class ChartView extends ListView implements IBeadView
	{
		public function ChartView()
		{
			super();
		}
		
		private var _strand:IStrand;
		private var _horizontalAxisGroup:IAxisGroup;
		private var _verticalAxisGroup:IAxisGroup;
		
		/**
		 *  @copy org.apache.flex.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		override public function set strand(value:IStrand):void
		{
			_strand = value;
						
			var listModel:ISelectionModel = _strand.getBeadByType(ISelectionModel) as ISelectionModel;
			listModel.addEventListener("dataProviderChanged", dataProviderChangeHandler);
			
			var haxis:IHorizontalAxisBead = _strand.getBeadByType(IHorizontalAxisBead) as IHorizontalAxisBead;
			if (haxis && _horizontalAxisGroup == null) {
				var m1:Class = ValuesManager.valuesImpl.getValue(_strand, "iHorizontalAxisGroup");
				_horizontalAxisGroup = new m1();
				haxis.axisGroup = _horizontalAxisGroup;
				IParent(_strand).addElement(_horizontalAxisGroup, false);
			}
			
			var vaxis:IVerticalAxisBead = _strand.getBeadByType(IVerticalAxisBead) as IVerticalAxisBead;
			if (vaxis && _verticalAxisGroup == null) {
				var m2:Class = ValuesManager.valuesImpl.getValue(_strand, "iVerticalAxisGroup");
				_verticalAxisGroup = new m2();
				vaxis.axisGroup = _verticalAxisGroup;
				IParent(_strand).addElement(_verticalAxisGroup, false);
			}
			
			super.strand = value;
		}
		
		override protected function completeSetup():void
		{
			if (border) {
				IParent(_strand).removeElement(border);
			}
					
			super.completeSetup();
		}
		
		public function get horizontalAxisGroup():IAxisGroup
		{
			return _horizontalAxisGroup;
		}
		
		public function get verticalAxisGroup():IAxisGroup
		{
			return _verticalAxisGroup;
		}
		
		/**
		 * @private
		 */
		override protected function dataProviderChangeHandler(event:Event):void
		{
			if (verticalAxisGroup) {
				verticalAxisGroup.removeAllElements();
			}
			
			if (horizontalAxisGroup) {
				horizontalAxisGroup.removeAllElements();
			}
			
			dataGroup.removeAllElements();
		}
				
		/**
		 * ChartView overrides performLayout so that the exact area of the ChartDataGroup can
		 * be calculated so the chart's layout algorithm knows precisely the dimensions of 
		 * chart for its item renderers.
		 */
		override protected function layoutViewBeforeContentLayout():void
		{			
			var metrics:Rectangle = CSSContainerUtils.getBorderAndPaddingMetrics(_strand);
			
			var widthAdjustment:Number = 0;
			var heightAdjustment:Number = 0;
			
			var vaxis:IVerticalAxisBead = _strand.getBeadByType(IVerticalAxisBead) as IVerticalAxisBead;
			var haxis:IHorizontalAxisBead = _strand.getBeadByType(IHorizontalAxisBead) as IHorizontalAxisBead;
			
			if (vaxis) {
				widthAdjustment = vaxis.axisWidth;
			}
			
			if (haxis) {
				heightAdjustment = haxis.axisHeight;
			}
			
			var strandWidth:Number = UIBase(_strand).width;
			var strandHeight:Number = UIBase(_strand).height;
			
            viewport.setPosition(widthAdjustment + metrics.left, metrics.top);
			viewport.layoutViewportBeforeContentLayout(strandWidth - widthAdjustment - metrics.right - metrics.left,
                                                        strandHeight - heightAdjustment - metrics.bottom - metrics.top);
            
			if (verticalAxisGroup) {
				UIBase(verticalAxisGroup).x = metrics.left;
				UIBase(verticalAxisGroup).y = metrics.top;
				UIBase(verticalAxisGroup).width = widthAdjustment;
				UIBase(verticalAxisGroup).height = strandHeight - heightAdjustment - metrics.bottom - metrics.top;
			}
			
			if (horizontalAxisGroup) {
				UIBase(horizontalAxisGroup).x = widthAdjustment + metrics.left;
				UIBase(horizontalAxisGroup).y = strandHeight - heightAdjustment - metrics.bottom;
				UIBase(horizontalAxisGroup).width = strandWidth - widthAdjustment - metrics.left - metrics.right;
				UIBase(horizontalAxisGroup).height = heightAdjustment;
			}
			
            /* viewport should be doing this now
			if (dataGroup) {
				UIBase(dataGroup).x = viewportModel.contentX;
				UIBase(dataGroup).y = viewportModel.contentY;
				UIBase(dataGroup).width = viewportModel.contentWidth;
				UIBase(dataGroup).height = viewportModel.contentHeight;
			} */
		}		
	}
}