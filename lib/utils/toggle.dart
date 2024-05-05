class Toggle{

  late bool _initialValue;
  late bool _value;

  Toggle({required bool initialValue}){
    _initialValue = initialValue;
    _value = initialValue;
  }

  bool get(){
    return _value;
  }

  toggle(){
    _value = !_value;
  }

  reset(){
    _value = _initialValue;
  }

}