use std::error::Error;

use jiff::{ToSpan, Zoned};
use rex::time::{hour::Hour, interval::IntervalLike};

fn count_hours() -> Result<(), Box<dyn Error>> {
    let start = "2023-01-01 00:00:00[America/New_York]".parse::<Zoned>()?;
    let end = start.saturating_add(5.years());
    let mut hour = Hour { start };
    let mut i = 0;
    while hour.start < end {
        hour = hour.next();
        i += 1;
    }
    println!("{i}");

    Ok(())
}

fn main() {
    count_hours().unwrap();
}
