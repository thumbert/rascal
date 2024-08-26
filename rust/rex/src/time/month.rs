use std::error::Error;
use std::fmt;
use std::fmt::{Debug, Formatter, Write};
use std::str::FromStr;

use jiff::civil::{date, Date};
use jiff::tz::TimeZone;
use jiff::{Span, ToSpan, Unit, Zoned};

use super::hour::Hour;
use super::interval::IntervalLike;

#[derive(PartialEq, Debug, Clone, Eq, PartialOrd, Ord)]
pub struct Month {
    start: Zoned,
}

impl Month {
    pub fn new(year: i16, month: i8, tz: TimeZone) -> Result<Month, Box<dyn Error>> {
        let start = date(year, month, 1).at(0, 0, 0, 0).to_zoned(tz)?;
        Ok(Month { start })
    }

    // pub fn from_int(yyyymm: u32, tz: Tz) -> Option<Month> {
    //     let year = i32::try_from(yyyymm / 100).unwrap();
    //     let month = yyyymm % 100;
    //     let start = tz.with_ymd_and_hms(year, month, 1, 0, 0, 0);
    //     match start {
    //         LocalResult::Single(start) => Some(Month { start }),
    //         LocalResult::Ambiguous(_, _) => panic!("Wrong inputs!"),
    //         LocalResult::None => None,
    //     }
    // }

    /// Return the hour that contains this datetime.
    pub fn containing(dt: &Zoned) -> Result<Month, Box<dyn Error>> {
        let start = date(dt.year(), dt.month(), 1)
            .at(0, 0, 0, 0)
            .to_zoned(dt.time_zone().clone())?;
        Ok(Month { start })
    }

    pub fn year(&self) -> i16 {
        self.start.year()
    }

    pub fn month(&self) -> i8 {
        self.start.month()
    }

    pub fn next(&self) -> Month {
        Month { start: self.end() }
    }

    pub fn day_count(&self) -> u8 {
        let span = self.start.until(&self.end()).unwrap();
        span.total(Unit::Day).unwrap().round() as u8
    }

    pub fn hour_count(&self) -> u16 {
        let span = self.start.until(&self.end()).unwrap();
        span.total(Unit::Hour).unwrap().round() as u16
    }

    pub fn hour_iter(&self) -> HourIterator {
        HourIterator {
            current: Hour {
                start: self.start.clone(),
            },
            month_end: self.end(),
        }
    }
}

impl IntervalLike for Month {
    fn start(&self) -> Zoned {
        self.start.clone()
    }

    fn end(&self) -> Zoned {
        self.start.checked_add(1.month()).unwrap()
    }
}

impl fmt::Display for Month {
    fn fmt(&self, f: &mut Formatter<'_>) -> fmt::Result {
        write!(f, "{}", &self.start.strftime("%Y-%m [%:V]"))
    }
}


impl TryFrom<(i32, TimeZone)> for Month {
    type Error = String;

    fn try_from(value: (i32, TimeZone)) -> Result<Self, Self::Error> {
        let year = i16::try_from(value.0 / 100).unwrap();
        let month = (value.0 % 100) as i8;
        let start = date(year, month, 1)
            .at(0, 0, 0, 0)
            .to_zoned(value.1)
            .unwrap();
        Ok(Month { start })
    }
}

pub struct HourIterator {
    current: Hour,
    month_end: Zoned,
}

impl Iterator for HourIterator {
    type Item = Hour;

    fn next(&mut self) -> Option<Self::Item> {
        if self.current.start < self.month_end {
            let res = Some(self.current.clone());
            self.current = self.current.next();
            res
        } else {
            None
        }
    }
}

#[cfg(test)]
mod tests {
    use std::error::Error;

    use jiff::{civil::date, tz::TimeZone, Unit, Zoned};

    use crate::time::{interval::IntervalLike, month::Month};

    #[test]
    fn test_month_utc() -> Result<(), Box<dyn Error>> {
        let dt = date(2022, 4, 15).at(3, 15, 20, 0).intz("UTC")?;
        let month = Month::containing(&dt)?;
        assert_eq!(month.start.hour(), 0);
        assert_eq!(month.start.day(), 1);
        assert_eq!(month.start.month(), 4);
        // println!("{:?}", month.next());
        assert_eq!(
            month.next(),
            Month {
                start: "2022-05-01 00:00:00[UTC]".parse()?
            }
        );
        assert!(month.contains(&dt));
        assert!(!month.contains(&"2022-05-01 00:00:00[UTC]".parse()?));
        Ok(())
    }

    #[test]
    fn test_month_ny() -> Result<(), Box<dyn Error>> {
        let month = Month::new(2024, 3, TimeZone::get("America/New_York")?)?;
        assert_eq!(month.year(), 2024);
        assert_eq!(month.month(), 3);
        assert_eq!(format!("{}", month), "2024-03 [America/New_York]");
        let month = month.next();
        assert_eq!(format!("{}", month), "2024-04 [America/New_York]");
        assert_eq!(month.time_zone().iana_name().unwrap(), "America/New_York");
        assert_eq!(
            Month::try_from((202404, TimeZone::get("America/New_York")?))?,
            month
        );
        Ok(())
    }

    #[test]
    fn test_month_eq() -> Result<(), Box<dyn Error>> {
        let tz = TimeZone::get("America/New_York")?;
        let m1 = Month::new(2024, 3, tz.clone())?;
        let m2 = Month::new(2024, 4, tz.clone())?;
        let m3 = Month::new(2024, 3, tz.clone())?;
        let m4 = m1.clone();
        assert!(m1 != m2);
        assert!(m1 == m3);
        assert_eq!(m1, m4);
        Ok(())
    }

    #[test]
    fn test_count() -> Result<(), Box<dyn Error>> {
        let tz = TimeZone::get("America/New_York")?;
        let m = Month::new(2024, 1, tz.clone())?;
        assert_eq!(m.hour_count(), 744);
        assert_eq!(m.day_count(), 31);
        let m = Month::new(2024, 2, tz.clone())?;
        assert_eq!(m.hour_count(), 696);
        assert_eq!(m.day_count(), 29);
        let m = Month::new(2024, 3, tz.clone())?;
        assert_eq!(m.hour_count(), 743); // DST
        let m = Month::new(2024, 11, tz.clone())?;
        assert_eq!(m.hour_count(), 721); // DST
        Ok(())
    }

    #[test]
    fn test_hour_iter() -> Result<(), Box<dyn Error>> {
        let tz = TimeZone::get("America/New_York")?;
        let m = Month::new(2024, 3, tz.clone())?;
        let mut it = m.hour_iter();
        // assert_eq!(it.current, Hou)

        // for hour in m.hour_iter() {
        //     println!("{}", hour);
        // }

        // println!("{:?}", it.next());
        // println!("{:?}", it.next());
        // println!("{:?}", it.next());
        // println!("{:?}", it.next());
        // println!("{:?}", it.next());
        Ok(())
    }
}
