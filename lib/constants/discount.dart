String discountPercent(int oldPrice , int currentPrice){
  if(oldPrice == 0 ){
    return "0";
  }else{
    double discount = ((oldPrice - currentPrice) / oldPrice * 100);
    return discount.toDouble().toStringAsFixed(0);
  }
}