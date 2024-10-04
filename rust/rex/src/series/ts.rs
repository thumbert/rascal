use super::interval::IntervalLike;
use std::slice::Iter;


pub struct TimeSeries<T: IntervalLike, K: Clone>(Vec<(T, K)>);


impl<T: IntervalLike, K: Clone> TimeSeries<T, K> {
    pub fn new() -> TimeSeries<T, K> {
        let v: Vec<(T, K)> = Vec::new();
        TimeSeries(v)
    }

    pub fn filled(intervals: Vec<T>, value: K) -> TimeSeries<T, K> {
        let mut v: Vec<(T, K)> = Vec::new();
        for t in intervals.into_iter() {
            let obs = (t, value.clone());
            v.push(obs);
        }
        TimeSeries(v)
    }

    pub fn push(&mut self, value: (T, K)) {
        // check that you only push at the end of the timeseries
        if !self.is_empty() {
            let obs = self.last().unwrap();
            if value.0.start() < obs.0.start() {
                panic!("You can only push at the end of a timeseries!");
            }
        }
        self.0.push(value);
    }

    pub fn first(&self) -> Option<&(T, K)> {
        // self.observations.first()
        self.0.first()
    }

    pub fn is_empty(&self) -> bool {
        self.0.is_empty()
    }

    pub fn iter(&self) -> Iter<'_, (T, K)> {
        self.0.iter()
    }

    pub fn last(&self) -> Option<&(T, K)> {
        self.0.last()
    }

    pub fn len(&self) -> usize {
        // self.observations.len()
        self.0.len()
    }
}

impl<T: IntervalLike, K: Clone> FromIterator<(T, K)> for TimeSeries<T, K> {
    fn from_iter<I: IntoIterator<Item = (T, K)>>(iter: I) -> Self {
        let mut c: TimeSeries<T, K> = TimeSeries::new();
        for i in iter {
            c.push(i);
        }
        c
    }
}

impl<T: IntervalLike, K: Clone> IntoIterator for TimeSeries<T, K> {
    type Item = (T, K);
    type IntoIter = std::vec::IntoIter<Self::Item>;
    fn into_iter(self) -> Self::IntoIter {
        self.0.into_iter()
    }
}
