package com.utils {
import flash.system.System;
import flash.utils.Dictionary;
import flash.utils.getQualifiedClassName;

public class MemoryTracker {
         
    private static var m_tracking: Dictionary = new Dictionary(true);

    private static var lastMemory: uint = 0;

    public static function track(obj: Object):void {
        if (!MemoryTracker.m_tracking[obj]) {
            MemoryTracker.m_tracking[obj] = 1;
        }
    }

    public static function logTracking():void {
        trace("Start logging");

        var dict: Object = {};
        var key: String;
        for (var obj: Object in m_tracking) {
            key = getQualifiedClassName(obj);
            if (!dict[key]) {
                dict[key] = 0;
            }
            dict[key]++;
        }

        for (key in dict) {
            trace(key, dict[key]);
        }

        trace("Stop logging");

        var memory: uint = System.totalMemory / 1024;
        trace("Memory used: " + memory + "Kb");
        if (lastMemory) {
            trace("Memory delta: " + (memory - lastMemory) + "Kb");
        }
        lastMemory = memory;
    }
}
}