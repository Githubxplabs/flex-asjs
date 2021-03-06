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

package org.apache.flex.effects
{

COMPILE::SWF
{
    import flash.display.DisplayObject;
    import flash.geom.Rectangle;            
}
COMPILE::JS
{
    import org.apache.flex.geom.Rectangle;
}

import org.apache.flex.core.IDocument;
import org.apache.flex.core.IUIBase;

/**
 *  Helper class for Wipe effects.
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10.2
 *  @playerversion AIR 2.6
 *  @productversion FlexJS 0.0
 */
public class PlatformWiper
{

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function PlatformWiper()
    {
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

	/**
	 *  @private
	 *  The target.
	 */
	private var _target:IUIBase;
      
    /**
     *  @private
     *  The old overflow value.
     */
    private var _overflow:String;
    
    /**
     *  The object that will be clipped.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function set target(value:IUIBase):void
    {
        COMPILE::SWF
        {
            if (value == null)
                DisplayObject(_target).scrollRect = null;
            _target = value;                
        }
        COMPILE::JS
        {
            if (value == null) 
            {
                if (_overflow == null)
                    delete _target.positioner.style["overflow"];
                else
                    _target.positioner.style.overflow = _overflow;
            }
            _target = value;
            if (value != null) {
                _overflow = _target.positioner.style.overflow;
            }
        }
    }
    
    /**
     *  The visible rectangle.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function set visibleRect(value:Rectangle):void
    {
        COMPILE::SWF
        {
            DisplayObject(_target).scrollRect = value;                
        }
        COMPILE::JS
        {
            _target.positioner.style.height = value.height.toString() + 'px';
            _target.positioner.style.overflow = 'hidden';
        }
    }
}

}
