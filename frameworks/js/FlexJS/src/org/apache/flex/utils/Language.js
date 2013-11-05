/**
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/*jshint globalstrict: true, indent: 2, maxlen: 80, strict: true, white: false */
/*global goog, org */

'use strict';

goog.provide('org.apache.flex.utils.Language');



/**
 * @constructor
 */
org.apache.flex.utils.Language = function() {
	//
};


/**
 * as()
 *
 * @expose
 * @param {!Object} leftOperand The lefthand operand of the
 *     binary as operator in AS3.
 * @param {!Object} rightOperand The righthand operand of the
 *     binary operator in AS3.
 * @return {?Object} Returns the lefthand operand if it is
 *     of the type of the righthand operand, otherwise null.
 */
org.apache.flex.utils.Language.as = function(leftOperand, rightOperand) {
	return (org.apache.flex.utils.Language.is(leftOperand, rightOperand)) ?
	    leftOperand : null;
};


/**
 * int()
 *
 * @expose
 * @param {*} value The value to be cast.
 * @return {number}
 */
org.apache.flex.utils.Language._int = function(value) {
	return value >> 0;
};


/**
 * is()
 *
 * @expose
 * @param {!Object} leftOperand The lefthand operand of the
 *     binary as operator in AS3.
 * @param {!Object} rightOperand The righthand operand of the
 *     binary operator in AS3.
 * @return {boolean}
 */
org.apache.flex.utils.Language.is = function(leftOperand, rightOperand) {
	var checkInterfaces;
	
	checkInterfaces = function (left) {
		var i, interfaces;
	
		interfaces = left.AFJS_INTERFACES;
		for (i = interfaces.length - 1; i > -1; i--) {
			if (interfaces[i] === rightOperand) {
				return true;
			} else if (interfaces[i].AFJS_INTERFACES) {
				return checkInterfaces(interfaces[i]);
			}
		}
	
		return false;
	}

	if (leftOperand instanceof rightOperand) {
		return true;
	} else if (leftOperand.AFJS_INTERFACES) {
		return checkInterfaces(leftOperand)
	}

	return false;
};


/**
 * trace()
 *
 * @expose
 * @param {string} value The message to be written to the console.
 */
org.apache.flex.utils.Language.trace = function(value) {
	try {
		if (console && console.log) {
			console.log(value);
		}
	} catch (e) {
		// ignore; at least we tried ;-)
	}
};


/**
 * uint()
 *
 * @expose
 * @param {*} value The value to be cast.
 * @return {number}
 */
org.apache.flex.utils.Language.uint = function(value) {
	return value >>> 0;
};