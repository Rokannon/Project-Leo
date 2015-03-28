package com.rokannon.core.enum
{
    import com.rokannon.core.errors.StaticClassError;

    public class StaticClassBase
    {
        public function StaticClassBase()
        {
            throw new StaticClassError();
        }
    }
}