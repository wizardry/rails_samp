body = 
  "testtesttest\n"+
  "hogehogehgohoge\n"+
  "fufuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu"

["rockenbelg","kragas","arome"].each do |name|
  member = Member.find_by(name: name)

  0.upto(9) do |index|
    puts("seed entries line:10" + ["draft","member_only","public"][index % 3 ])
    entry = Entry.create(
      author: member,
      title: "blog result num :#{index}",
      body: body,
      posted_at: 10.days.ago.advance(dyas: index),
      status: ["draft","member_only","public"][index % 3 ]
    )

    if index == 7 || index == 8
      ["ironic","forlimer","ezocco"].each do |name2|
        voter = Member.find_by(name: name2)
        voter.voted_entries << entry
      end
    end
  end
end