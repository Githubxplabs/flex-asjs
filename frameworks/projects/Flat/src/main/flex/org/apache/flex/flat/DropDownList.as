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
package org.apache.flex.flat
{
    import org.apache.flex.core.UIBase;

    COMPILE::SWF
    {
        import org.apache.flex.html.DropDownList;            
    }
    COMPILE::JS
    {
        import goog.events;
        import org.apache.flex.core.ListBase;
        import org.apache.flex.core.WrappedHTMLElement;
        import org.apache.flex.core.ISelectionModel;
        import org.apache.flex.events.Event;
        import org.apache.flex.html.beads.models.ArraySelectionModel;
        import org.apache.flex.utils.CSSUtils;
    }
    
    /**
     *  The DropDownList class provides a FlatUI-like appearance for
     *  a DropDownList.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    COMPILE::SWF
	public class DropDownList extends org.apache.flex.html.DropDownList
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function DropDownList()
		{
			super();
		}
	}
    
    COMPILE::JS
    public class DropDownList extends ListBase
    {
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function DropDownList()
        {
            super();
            model = new ArraySelectionModel();
        }

        private var label:HTMLSpanElement;
        private var button:HTMLButtonElement;
        private var caret:HTMLSpanElement;
        private var menu:HTMLUListElement;
        
        /**
         * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
         * @flexjsignorecoercion HTMLButtonElement
         * @flexjsignorecoercion HTMLDivElement
         * @flexjsignorecoercion HTMLSpanElement
         */
        override protected function createElement():WrappedHTMLElement
        {
            var button:HTMLButtonElement;
            var outer:HTMLDivElement;
            var caret:HTMLSpanElement;
            
            this.element = document.createElement('div') as WrappedHTMLElement;
            outer = this.element as HTMLDivElement;
            
            this.button = button = document.createElement('button') as HTMLButtonElement;
            button.className = 'dropdown-toggle-open-btn';
            if (this.className)
                button.className += ' ' + this.className;
            goog.events.listen(button, 'click', buttonClicked);
            outer.appendChild(button);
            
            this.label = document.createElement('span') as HTMLSpanElement;
            this.label.className = 'dropdown-label';
            button.appendChild(this.label);
            this.caret = caret = document.createElement('span') as HTMLSpanElement;
            button.appendChild(caret);
            caret.className = 'dropdown-caret';
            
            this.positioner = this.element;
            this.positioner.style.position = 'relative';
            
            // add a click handler so that a click outside of the combo box can
            // dismiss the pop-up should it be visible.
            goog.events.listen(document, 'click', dismissPopup);
            
            (button as WrappedHTMLElement).flexjs_wrapper = this;
            this.element.flexjs_wrapper = this;
            (this.label as WrappedHTMLElement).flexjs_wrapper = this;
            (caret as WrappedHTMLElement).flexjs_wrapper = this;
            
            return this.element;
        }
        
        
        /**
         * @param event The event.
         * @flexjsignorecoercion org.apache.flex.core.UIBase 
         */
        private function selectChanged(event:Event):void
        {
            var select:UIBase;
            
            select = event.target as UIBase;
            
            this.selectedIndex = parseInt(select.id, 10);
            
            this.menu.parentNode.removeChild(this.menu);
            this.menu = null;
            
            this.dispatchEvent('change');
        }
        
        
        /**
         * @param event The event.
         */
        private function dismissPopup(event:Event = null):void
        {
            // remove the popup if it already exists
            if (this.menu) 
            {
                this.menu.parentNode.removeChild(this.menu);
                this.menu = null;
            }
        }
        
        
        /**
         * @param event The event.
         * @flexjsignorecoercion Array
         * @flexjsignorecoercion HTMLButtonElement
         * @flexjsignorecoercion HTMLUListElement
         * @flexjsignorecoercion HTMLLIElement
         * @flexjsignorecoercion HTMLAnchorElement
         */
        private function buttonClicked(event:Event):void
        {
            var dp:Array;
            var i:int;
            var button:HTMLButtonElement;
            var left:Number;
            var n:int;
            var opt:HTMLLIElement;
            var opts:Array;
            var pn:HTMLDivElement;
            var select:HTMLUListElement;
            var top:Number;
            var width:Number;
            
            event.stopPropagation();
            
            if (this.menu) 
            {
                this.dismissPopup();    
                return;
            }
            
            button = this.element.childNodes.item(0) as HTMLButtonElement;
            
            pn = this.element as HTMLDivElement;
            top = pn.offsetTop + button.offsetHeight;
            left = pn.offsetLeft;
            width = pn.offsetWidth;
                        
            this.menu = select = document.createElement('ul') as HTMLUListElement;
            var el:Element =  element as Element;
            var cv:Object = getComputedStyle(el);
            select.style.width = cv.width;
            goog.events.listen(select, 'click', selectChanged);
            select.className = 'dropdown-menu';
            
            var lf:String = this.labelField;
            dp = dataProvider as Array;
            n = dp.length;
            for (i = 0; i < n; i++) {
                opt = document.createElement('li') as HTMLLIElement;
                opt.style.backgroundColor = 'transparent';
                var ir:HTMLAnchorElement = document.createElement('a') as HTMLAnchorElement;
                if (lf)
                    ir.innerHTML = dp[i][lf];
                else
                    ir.innerHTML = dp[i];
                ir.id = i.toString();
                if (i == this.selectedIndex)
                    ir.className = 'dropdown-menu-item-renderer-selected';
                else
                    ir.className = 'dropdown-menu-item-renderer';
                opt.appendChild(ir);
                select.appendChild(opt);
            }
            
            this.element.appendChild(select);
        };
        
        
        /**
         */
        override public function addedToParent():void
        {
            super.addedToParent();
            var el:Element = button as Element;
            var cv:Object = getComputedStyle(el);
            var s:String = cv.paddingLeft;
            var pl:Number = CSSUtils.toNumber(s);
            s = cv.paddingRight;
            var pr:Number = CSSUtils.toNumber(s);
            s = cv.borderLeftWidth;
            var bl:Number = CSSUtils.toNumber(s);
            s = cv.borderRightWidth;
            var br:Number = CSSUtils.toNumber(s);
            var caretWidth:Number = this.caret.offsetWidth;
            // 10 seems to factor spacing between span and extra FF padding?
            var fluff:Number = pl + pr + bl + br + caretWidth + 1 + 10;
            var labelWidth:Number = this.width - fluff;
            var strWidth:String = labelWidth.toString();
            strWidth += 'px';
            this.label.style.width = strWidth;
        }       
        
        override public function set className(value:String):void
        {
            super.className = value;
            if (this.button) {
                this.button.className = this.typeNames ?
                value + ' ' + 'dropdown-toggle-open-btn' + ' ' + this.typeNames :
                value + ' ' + 'dropdown-toggle-open-btn';
            }
        }
        
        /**
         *  The data set to be displayed.  Usually a simple
         *  array of strings.  A more complex component
         *  would allow more complex data and data sets.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function get dataProvider():Object
        {
            return ISelectionModel(model).dataProvider;
        }
        
        /**
         *  @private
         *  @flexjsignorecoercion HTMLOptionElement
         *  @flexjsignorecoercion HTMLSelectElement
         */
        public function set dataProvider(value:Object):void
        {
            ISelectionModel(model).dataProvider = value;
        }
        
        /**
         *  The name of field within the data used for display. Each item of the
         *  data should have a property with this name.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function get labelField():String
        {
            return ISelectionModel(model).labelField;
        }
        public function set labelField(value:String):void
        {
            ISelectionModel(model).labelField = value;
        }

        [Bindable("change")]
        /**
         *  @copy org.apache.flex.core.ISelectionModel#selectedIndex
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function get selectedIndex():int
        {
            return ISelectionModel(model).selectedIndex;
        }
        
        /**
         *  @private
         *  @flexjsignorecoercion HTMLSelectElement
         *  @flexjsignorecoercion String
         */
        public function set selectedIndex(value:int):void
        {
            ISelectionModel(model).selectedIndex = value;
            var lf:String = this.labelField;
            if (lf)
                this.label.innerHTML = this.selectedItem[lf] as String;
            else
                this.label.innerHTML = this.selectedItem as String;
        }
        
        
        [Bindable("change")]
        /**
         *  @copy org.apache.flex.core.ISelectionModel#selectedItem
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function get selectedItem():Object
        {
            return ISelectionModel(model).selectedItem;
        }
        
        /**
         *  @private
         *  @flexjsignorecoercion HTMLSelectElement
         *  @flexjsignorecoercion String
         */
        public function set selectedItem(value:Object):void
        {
            ISelectionModel(model).selectedItem = value;
            var lf:String = this.labelField;
            if (lf)
                this.label.innerHTML = this.selectedItem[lf] as String;
            else
                this.label.innerHTML = this.selectedItem as String;
        }
    }
}
