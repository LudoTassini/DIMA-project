class Toggle{

  bool _value = true;

  Toggle({required bool initialValue}){
    _value = initialValue;
  }

  bool get(){
    return _value;
  }

  toggle(){
    _value = !_value;
  }

}