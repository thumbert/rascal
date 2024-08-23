use jiff::Timestamp;

/// https://blog.burntsushi.net/rust-error-handling/

fn main() {
    let xs = "1706763600,74a02,1709269200";

    let res = xs
        .split(',')
        .map(|e| e.parse::<i64>())
        .collect::<Result<Vec<i64>, _>>()
        .map(|seconds| {
            seconds
                .iter()
                .map(|e| Timestamp::from_second(*e))
                .collect::<Result<Vec<Timestamp>, _>>()
        });

    // version 2 -- BETTER, only one collect and doesn't create a nested Return
    let res2 = xs
        .split(',')
        .map(|n| {
            n.parse::<i64>()
                .map_err(|_| format!("Failed to parse {} to an integer", n))
                .and_then(|e| Timestamp::from_second(e).map_err(|e| e.to_string()))
        })
        .collect::<Result<Vec<Timestamp>, _>>();

    // todo:  parse everything except the ones that error 

    println!("{:?}", res);

    println!("{:?}", res2);
}
