use core::fmt;
use std::{fmt::Formatter, str::FromStr};

use jiff::{civil::date, Timestamp, ToSpan, Zoned};

use super::interval::IntervalLike;

#[derive(PartialEq, Debug, Clone, Eq, PartialOrd, Ord)]
pub struct Hour {
    pub start: Zoned, // TODO remove pub!
}

impl Hour {
    /// Return the hour that contains this datetime.
    pub fn containing(dt: Zoned) -> Hour {
        let second = 3600 * (dt.timestamp().as_second() / 3600);
        let start = Timestamp::from_second(second)
            .unwrap()
            .to_zoned(dt.time_zone().clone());
        Hour { start }
    }

    pub fn next(&self) -> Hour {
        Hour { start: self.end() }
    }
    pub fn previous(&self) -> Hour {
        Hour {
            start: self.start.saturating_sub(1.hour()),
        }
    }
}

impl fmt::Display for Hour {
    fn fmt(&self, f: &mut Formatter<'_>) -> fmt::Result {
        write!(
            f,
            "{}->{}",
            &self.start.strftime("%Y-%m-%d %H"),
            &self.end().strftime("%H [%:V]")
        )
    }
}

impl FromStr for Hour {
    type Err = String;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        // TODO implement this! 
        let year = 2024;
        let month = 3;
        let day = 1;
        let hour = 0;
        let tz_name = "America/New_York";

        let start = date(year, month, day).at(hour, 0, 0, 0)
            .intz(tz_name);
        match start {
            Ok(v) => Ok(Hour { start: v}),
            Err(e) => Err(e.to_string()),
        }
    }
}

impl IntervalLike for Hour {
    fn start(&self) -> Zoned {
        self.start.clone()
    }

    fn end(&self) -> Zoned {
        self.start.saturating_add(1.hour())
    }
}

#[cfg(test)]
mod tests {
    use jiff::Zoned;
    use std::error::Error;

    use crate::time::interval::IntervalLike;

    use super::Hour;

    #[test]
    fn test_hour() -> Result<(), Box<dyn Error>> {
        let start = "2024-01-01 00:00:00[America/New_York]".parse::<Zoned>()?;
        let hour = Hour { start };
        assert_eq!(
            hour.end(),
            "2024-01-01 01:00:00[America/New_York]".parse::<Zoned>()?
        );

        // let next_hour = hour.next();
        // assert_eq!(next_hour.start(), hour.end());
        // println!("{}", hour);
        Ok(())
    }

    #[test]
    fn test_containing() -> Result<(), Box<dyn Error>> {
        let dt = "2024-01-01 00:14:10-05:00[America/New_York]".parse::<Zoned>()?;
        assert_eq!(
            Hour::containing(dt).start(),
            "2024-01-01 00:00:00-05:00[America/New_York]".parse::<Zoned>()?
        );
        //
        let dt = "2024-11-03 01:14:10-05:00[America/New_York]".parse::<Zoned>()?;
        assert_eq!(
            Hour::containing(dt).start(),
            "2024-11-03 01:00:00-05:00[America/New_York]".parse::<Zoned>()?
        );
        //
        let dt = "2024-11-03 01:14:10-04:00[America/New_York]".parse::<Zoned>()?;
        assert_eq!(
            Hour::containing(dt).start(),
            "2024-11-03 01:00:00-04:00[America/New_York]".parse::<Zoned>()?
        );
        Ok(())
    }

    // #[test]
    // fn test_iter() -> Result<(), Box<dyn Error>> {
    //     let dt = "2024-01-01 00:14:10-05:00[America/New_York]".parse::<Zoned>()?;
    //     let h0 = Hour::containing(dt);

    //     let mut hours = h0.into_iter();
    //     println!("{}", hours.next().unwrap());
    //     println!("{}", hours.next().unwrap());
    //     // println!("{}", hours.next().unwrap());
    //     // println!("{}", hours.next().unwrap());
    //     // println!("{}", hours.next().unwrap());

    //     Ok(())
    // }
}
