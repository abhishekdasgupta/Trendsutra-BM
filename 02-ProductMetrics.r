

#App Information Pull

AppAwareness.Traffic <- GetReportData( QueryBuilder( Init(
  start.date = StartDate, end.date = EndDate,
  metrics = "ga:sessions, ga:"
)))
