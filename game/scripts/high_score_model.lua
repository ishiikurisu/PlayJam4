high_score_model = {}
local pd <const> = playdate

local HIGH_SCORE_FILE_NAME <const> = "high_score.txt"

high_score_model.get_high_score = function()
  local result = 0
  local fp, oops = pd.file.open(HIGH_SCORE_FILE_NAME, pd.file.kFileRead)

  if oops == nil then
    result = tonumber(fp:readline())
    fp:close()
  end

  return result
end

high_score_model.set_high_score = function(high_score)
  fp, _ = pd.file.open(HIGH_SCORE_FILE_NAME, pd.file.kFileWrite)
  fp:write("" .. high_score .. "\n")
  fp:flush()
  fp:close()
end

high_score_model.maybe_set_high_score = function(score)
  local previous_high_score = high_score_model.get_high_score()
  local is_new_high_score = false

  if score > previous_high_score then
    is_new_high_score = true
    high_score_model.set_high_score(score)
  end

  return is_new_high_score
end

