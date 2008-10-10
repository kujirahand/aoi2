class FuncFrame
{
    var localvar:/*Object*/Array;
    var return_index:Number;
    var is_void_function:Boolean;
    
    function FuncFrame() {
        localvar = new Array();
        return_index = -1;
        is_void_function = false;
    }
}
