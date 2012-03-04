Audio = class()

--sound(DATA, "ZgFAMgApQEBAQEBAAAAAAK0sGT1UnpQ+QABAf0BJQEBAQEBA")

function Audio:init()
    self.sounds = {
        jump = "ZgJAKwBQQEBAQEBAAAAAAB5Mcz7AglM+QABAf0BAQEBAQEBA",
        kickBlock = "ZgJARAAmQEBAQEBAAAAAABlTij0iJm8+QABAf0BAQEBAQEBA",
        blockKaboom = "ZgNAAwBGQEBAUkdAAAAAAAeGyz5FH50+awBAf0BAQEBAQEBA",
        takeCoin = "ZgBAUgZAQEBAQEBA0fFzPSXsuz7o0Rg/WABAf0BAQEBAQGZN",
        dugrixDie = "ZgFAOgBBO05ERwV9s8KgvTKqkD068BI/YgB0dkBDDXEDHnYp",
        goombaDie = "ZgFAMgApQEBAQEBAAAAAAK0sGT1UnpQ+QABAf0BJQEBAQEBA"
    }
end

function Audio:play(aSound)
    sound(DATA, aSound)
end
