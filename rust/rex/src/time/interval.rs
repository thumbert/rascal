use jiff::{tz::TimeZone, Zoned};


pub trait IntervalLike {
    fn start(&self) -> Zoned;
    fn end(&self) -> Zoned;
    fn time_zone(&self) -> TimeZone {
        self.start().time_zone().clone()
    }

    /// Check if this interval contains a zoned datetime
    fn contains(&self, zdt: &Zoned) -> bool {
        zdt >= self.start() && zdt < self.end()
    }
}