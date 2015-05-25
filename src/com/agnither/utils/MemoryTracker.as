package com.agnither.utils {
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
        var log: String = "";
        log += "Start logging\n";

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
            log += "- " + key + ": " + dict[key] + "\n";
        }

        log += "Stop logging\n";

        var memory: uint = System.totalMemory;
        var memoryMb: String = (memory / 1024 / 1024).toFixed(1);
        var memoryLine: String = "Memory used: [mb] Mb\n";
        log += memoryLine.replace("[mb]", memoryMb);

        if (lastMemory) {
            var memoryDeltaLine: String = "Memory delta: [kb] Kb\n";
            log += memoryDeltaLine.replace("[kb]", (memory - lastMemory) / 1024);
        }
        lastMemory = memory;

        trace(log);
    }
}
}