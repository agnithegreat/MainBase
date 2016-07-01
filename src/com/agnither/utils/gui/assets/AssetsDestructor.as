/**
 * Created by alekseykabanov on 30.06.16.
 */
package com.agnither.utils.gui.assets
{
    public class AssetsDestructor
    {
        public var name : String = "";
        public var destructor : Function = null;

        public function AssetsDestructor(name : String, destructor : Function)
        {
            this.name = name;
            this.destructor = destructor;
        }

        public function execute():void
        {
            if(destructor != null){
                destructor(name);
            }
        }
    }
}
