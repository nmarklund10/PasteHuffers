require 'fileutils'
require 'zip'
require 'tempfile'
#skeleton code, logs, and submissions
class FileIO
    def self.constructFileName(iuid,cuid,auid,suid,isLog,language=nil)
        if isLog then
            return File.join(Rails.root.join("files", iuid.to_s, cuid.to_s, auid.to_s).to_s , suid.to_s + "-log.txt")
        end
        if language == nil then
            return ""
        end
        return File.join(Rails.root.join("files", iuid.to_s, cuid.to_s, auid.to_s).to_s ,suid.to_s + "-submission" + get_file_extension(language))
    end

    def self.generateZipFile(iuid,cuid,auid)
        tmp = Tempfile.new(["all-submissions",".zip"])
        zipFile = ZipFileGenerator.new(Rails.root.join("files", iuid.to_s, cuid.to_s, auid.to_s).to_s, Rails.root.join("files", iuid.to_s, cuid.to_s, auid.to_s).to_s+"allsubmissions.zip")
        zipFile.write
        return Rails.root.join("files", iuid.to_s, cuid.to_s, auid.to_s).to_s+"allsubmissions.zip"#tmp.path
        # entries = Dir.entries(Rails.root.join("files", iuid.to_s, cuid.to_s, auid.to_s).to_s) - %w(. ..)

        # Zip::File.open(File.join(Rails.root.join("files", iuid.to_s, cuid.to_s, auid.to_s).to_s, "all-submissions.zip")), Zip::File::CREATE) do |zipfile|
        #     write_entries entries, '', zipfile
        # end
        # return File.join(Rails.root.join("files", iuid.to_s, cuid.to_s, auid.to_s).to_s, "all-submissions.zip")
    end

  
    def self.get_file_extension(language)
        if (language == "Python")
            return ".py"
        elsif (language == "Ruby")
            return ".rb"
        elsif (language == "Java")
            return ".java"
        elsif (language == "C++")
            return ".cpp"
        elsif (language == "C")
            return ".c"
        else
            return ".txt"
        end
    end
    def self.write_log(iuid,cuid,auid,suid,input)
        path = Rails.root.join("files", iuid.to_s, cuid.to_s, auid.to_s)
        puts path
        puts auid
        FileUtils.makedirs(path)
        path = File.join(path.to_s, suid.to_s + "-log.txt")
        File.write(path, input)
    end
    def self.write_submission(iuid,cuid,auid,suid,input,language)
        path = Rails.root.join("files", iuid.to_s, cuid.to_s, auid.to_s)
        FileUtils.makedirs(path)
        path = File.join(path.to_s, suid.to_s + "-submission" + get_file_extension(language))
        File.write(path, input)
    end
    def self.cleanLog(iuid,cuid,auid,suid)
        begin
            path = Rails.root.join("files", iuid.to_s, cuid.to_s, auid.to_s)
            path = File.join(path.to_s, suid.to_s + "-log.txt")
            FileUtils.rm(path)
        rescue Exception => e
            puts e
            return
        end
    end
    def self.cleanCode(iuid,cuid,auid,suid,language)
        begin
            path = Rails.root.join("files", iuid.to_s, cuid.to_s, auid.to_s)
            path = File.join(path.to_s, suid.to_s + "-submission" + get_file_extension(language))
            FileUtils.rm(path)
        rescue Exception => e
            puts e
            return
        end
    end
    def self.write_skeleton_code(iuid,cuid,auid,input,language)
        path = Rails.root.join("files", iuid.to_s, cuid.to_s, auid.to_s)
        FileUtils.makedirs(path)
        path = File.join(path.to_s, "skeleton_code" + get_file_extension(language))
        File.write(path, input)
        puts "wrote to " + path.to_s
    end
    
    def self.read_log(iuid,cuid,auid,suid)
        path = Rails.root.join("files", iuid.to_s, cuid.to_s, auid.to_s, suid.to_s + "-log.txt")
        File.read(path)
    end
    def self.read_submission(iuid,cuid,auid,suid,language)
        path = Rails.root.join("files", iuid.to_s, cuid.to_s, auid.to_s, suid.to_s + "-submission" + get_file_extension(language))
        File.read(path)
    end
    def self.read_skeleton_code(iuid,cuid,auid,language)
        path = Rails.root.join("files", iuid.to_s, cuid.to_s, auid.to_s, "skeleton_code" + get_file_extension(language))
        if (!File.exist?(path))
            return ""
        end
        File.read(path)
    end
    
    def self.delete_submission(iuid,cuid,auid,suid,language)
        path = Rails.root.join("files", iuid.to_s, cuid.to_s, auid.to_s, suid.to_s + "-submission" + get_file_extension(language))
        File.delete(path)
    end
    def self.delete_assignment(iuid,cuid,auid)
        path = Rails.root.join("files", iuid.to_s, cuid.to_s, auid.to_s)
        FileUtils.rm_r(path)
    end
    def self.delete_course(iuid,cuid)
        path = Rails.root.join("files", iuid.to_s, cuid.to_s)
        FileUtils.rm_r(path)
    end
    def self.delete_instructor(iuid)
        path = Rails.root.join("files", iuid.to_s)
        FileUtils.rm_r(path)        
    end
end



#
# The following class was taken from an example at https://github.com/rubyzip/rubyzip
# PasteHuffers did not create the code below, we are merely using it
#

# This is a simple example which uses rubyzip to
# recursively generate a zip file from the contents of
# a specified directory. The directory itself is not
# included in the archive, rather just its contents.
#
# Usage:
#   directory_to_zip = "/tmp/input"
#   output_file = "/tmp/out.zip"
#   zf = ZipFileGenerator.new(directory_to_zip, output_file)
#   zf.write()
class ZipFileGenerator
    # Initialize with the directory to zip and the location of the output archive.
    def initialize(input_dir, output_file)
      @input_dir = input_dir
      @output_file = output_file
    end
  
    # Zip the input directory.
    def write
      entries = Dir.entries(@input_dir) - %w(. ..)
  
      ::Zip::File.open(@output_file, ::Zip::File::CREATE) do |zipfile|
        write_entries entries, '', zipfile
      end
    end
  
    private
  
    # A helper method to make the recursion work.
    def write_entries(entries, path, zipfile)
      entries.each do |e|
        zipfile_path = path == '' ? e : File.join(path, e)
        disk_file_path = File.join(@input_dir, zipfile_path)
        puts "Deflating #{disk_file_path}"
  
        if File.directory? disk_file_path
          recursively_deflate_directory(disk_file_path, zipfile, zipfile_path)
        else
          put_into_archive(disk_file_path, zipfile, zipfile_path)
        end
      end
    end
  
    def recursively_deflate_directory(disk_file_path, zipfile, zipfile_path)
      zipfile.mkdir zipfile_path
      subdir = Dir.entries(disk_file_path) - %w(. ..)
      write_entries subdir, zipfile_path, zipfile
    end
  
    def put_into_archive(disk_file_path, zipfile, zipfile_path)
      zipfile.get_output_stream(zipfile_path) do |f|
        f.write(File.open(disk_file_path, 'rb').read)
      end
    end
  end