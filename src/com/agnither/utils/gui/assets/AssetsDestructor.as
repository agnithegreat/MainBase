/**
 * Created by alekseykabanov on 30.06.16.
 */
package com.agnither.utils.gui.assets
{
    public class AssetsDestructor
    {
        public var name : String = "";
        public var type : String = "";
        public var destructor : Function = null;
        
        public function get fullName():String
        {
            return type != null && type.length > 0 ? type + "." + name : name;
        }

        public function AssetsDestructor(name : String, type: String, destructor : Function)
        {
            this.name = name;
            this.type = type;
            this.destructor = destructor;
        }

        public function execute():void
        {
            if (destructor != null)
            {
                destructor(name);
            }
        }
    }
}
