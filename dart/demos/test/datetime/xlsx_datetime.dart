

DateTime convertXlsxDateTime(num x) =>
    new DateTime.fromMillisecondsSinceEpoch(((x - 25569) * 86400000).round(),
        isUtc: true);

