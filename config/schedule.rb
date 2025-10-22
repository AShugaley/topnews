every 15.minute do
  runner "GetStoriesJob.perform_later"
  runner "LoadLibraryJob.perform_later"
end
