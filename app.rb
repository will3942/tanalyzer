require './tanalyzer.rb'
require 'sinatra'
require 'zip/zip'
require 'securerandom'

get '/' do
  erb :index
end

post '/analysis' do
  file = params['tweets_zip']
  if file[:type] == "application/zip"
    directory = SecureRandom.hex(13)
    Zip::ZipFile.open(file[:tempfile]) do |zipfile|
     zipfile.each do |file|
       filepath = File.join(directory, file.name)
       FileUtils.mkdir_p(File.dirname(filepath))
       zipfile.extract(file, filepath) unless File.exist?(filepath)
     end
    end
    if File.directory?(directory + "/data/js")
      @analysis = JSON.parse(TAnalyzer.new(directory + "/data/js/").data)
      FileUtils.rm_rf(directory)
      erb :analysis
    else
      FileUtils.rm_rf(directory)
      "Please upload the zip file that you downloaded from twitter."
    end
  else
    "Please upload a valid zip file."
  end
end