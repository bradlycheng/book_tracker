Book.destroy_all

Book.create!([
  { title: "The Pragmatic Programmer", author: "Hunt & Thomas" },
  { title: "Designing Data-Intensive Applications", author: "Kleppmann" },
  { title: "Refactoring", author: "Fowler" },
  { title: "The Mythical Man-Month", author: "Brooks" }
])
