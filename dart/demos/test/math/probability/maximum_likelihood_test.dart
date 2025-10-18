/// Try to see if you can detect a change in distribution parameters via maximum
/// likelihood estimation.  Assume that the distribution is normal with unknown
/// mean and variance.

import 'dart:math' as math;

// import 'package:dama/dama.dart';
import 'package:dama/distribution/gaussian_distribution.dart';
import 'package:elec_server/utils.dart';

// Generate n data points from N(mu, sigma)
List<num> generateData(int n, double mu, double sigma) {
  final gauss = GaussianDistribution(mu: mu, sigma: sigma);
  gauss.rand = math.Random(0);
  return List<num>.generate(n, (_) => gauss.sample());
}

/// Compute the log-likelihood of the data under a normal distribution with
/// parameters mu and sigma.
num logLikelihood(List<num> data, double mu, double sigma) {
  if (data.isEmpty) return double.negativeInfinity;

  final squaredDiffs = data.map((x) => math.pow(x - mu, 2)).toList();
  final sigma2 = squaredDiffs.reduce((a, b) => a + b) / data.length;

  // Log-likelihood for normal distribution
  return -0.5 * data.length * math.log(2 * math.pi * sigma2) -
      squaredDiffs.reduce((a, b) => a + b) / (2 * sigma2);
}

void main() {
  final data = [
    ...generateData(100, 0, 1),
    ...generateData(100, 5, 2),
  ];

  /// Calculate a moving statistic over the data to see if we can detect
  /// a change in distribution parameters.
  final windowSize = 19;
  var logLikelihoods = <num>[];
  for (var i = 0; i < data.length; i++) {
    var chunk = data.sublist(math.max(0, i - windowSize + 1), i + 1);
    logLikelihoods.add(logLikelihood(chunk, 0, 1));
  }
  print('${logLikelihoods.join('\n')}');

  var traces = [
    {
      'x': List<int>.generate(data.length, (i) => i),
      'y': logLikelihoods,
      'type': 'scatter',
      'mode': 'lines+markers',
      'name': 'Log-Likelihood',
    },
  ];
  var layout = {
    'title': 'Log-Likelihood over Time',
    'xaxis': {'title': 'Data Point Index'},
    'yaxis': {'title': 'Log-Likelihood'},
  };  
  Plotly.now(traces, layout, version: '3.1.0');
}
