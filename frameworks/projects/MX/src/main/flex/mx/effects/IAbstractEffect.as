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

package mx.effects
{

COMPILE::AS3
{
	import flash.events.IEventDispatcher;		
}
COMPILE::JS
{
	import org.apache.flex.events.IEventDispatcher;		
}

/**
 *  The IAbstractEffect interface is used to denote
 *  that a property or parameter must be of type Effect,
 *  but does not actually implement any of the APIs of the 
 *  IEffect interface.
 *  The UIComponent class recognizes when property that 
 *  implements the AbstractEffect interface changes, and passes it to 
 *  the EffectManager class for processing.
 *
 *  @see mx.effects.IEffect
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public interface IAbstractEffect extends IEventDispatcher
{
}

}