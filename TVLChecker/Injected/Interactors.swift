extension Container {
  
  /// Список интеракторов
  struct Interactors {
    
//    let authInteractor: AuthInteractor
//
//    let cyclesInteractor: CyclesInteractor
//
//    let calendarInteractor: CalendarInteractor
    
    /// Заглушка
    static var stub: Self {
      .init(
//        StubAuthInteractor(),
//        StubCyclesInteractor(),
//        StubCalendarInteractor()
      )
    }
    
    init(
//      _ authInteractor: AuthInteractor,
//      _ cyclesInteractor: CyclesInteractor,
//      _ calendarInteractor: CalendarInteractor
    ) {
//      self.authInteractor     = authInteractor
//      self.cyclesInteractor   = cyclesInteractor
//      self.calendarInteractor = calendarInteractor
    }
  }
}
