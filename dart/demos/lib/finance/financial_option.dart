library finance.financial_option;

abstract class FinancialOption {
  num value();
  num delta();
  num gamma();
  num vega();
  num theta();
}