-- Additive on top of the lang.ruby extra's own neotest-rspec: the real
-- projects here (Gift, Scribe) use Minitest, not RSpec.
return {
  {
    "nvim-neotest/neotest",
    dependencies = { "nvim-neotest/nvim-nio", "zidhuss/neotest-minitest" },
    opts = {
      adapters = { ["neotest-minitest"] = {} },
    },
  },
}
