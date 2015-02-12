/**
 * Created by kirillvirich on 12.02.15.
 */
package com.agnither.utils.gui.font {

public class CharsetUtil {

    public static function getChars(charSet: String):String {
        var chars: String = "";
        if (charSet) {
            var char: String;
            var lastChar: String;

            var l: int = charSet.length;
            for (var i:int = 0; i < l; i++) {
                char = charSet.charAt(i);
                if (lastChar) {
                    chars += getUnicodeRange(lastChar.charCodeAt(0), char.charCodeAt(0));
                    lastChar = null;
                } else if (l > i+2 && charSet.charAt(i+1) == "-") {
                    lastChar = char;
                    i++;
                } else {
                    chars += char;
                }
            }
        }
        return chars;
    }

    private static function getUnicodeRange(from: uint, to: uint):String {
        var range: String = "";
        for (var i:int = from; i <= to; i++) {
            range += String.fromCharCode(i);
        }
        return range;
    }
}
}
