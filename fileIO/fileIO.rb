require 'fileutils'
#skeleton code, logs, and submissions
class FileIO
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
        FileUtils.makedirs(path)
        path = File.join(path.to_s, suid.to_s + "-log")
        File.write(path, input)
    end
    def self.write_code(iuid,cuid,auid,suid,input,language)
        path = Rails.root.join("files", iuid.to_s, cuid.to_s, auid.to_s)
        FileUtils.makedirs(path)
        path = File.join(path.to_s, suid.to_s + "-code" + get_file_extension(language))
        File.write(path, input)
    end
    def self.write_skeleton_code(iuid,cuid,auid,input,language)
        path = Rails.root.join("files", iuid.to_s, cuid.to_s)
        FileUtils.makedirs(path)
        path = File.join(path.to_s, auid.to_s + "-skeleton_code" + get_file_extension(language))
        File.write(path, input)
        puts "wrote to " + path.to_s
    end
    
    def self.read_log(iuid,cuid,auid,suid)
        path = Rails.root.join("files", iuid.to_s, cuid.to_s, auid.to_s, suid.to_s + "-log")
        File.read(path)
    end
    def self.read_code(iuid,cuid,auid,suid,language)
        path = Rails.root.join("files", iuid.to_s, cuid.to_s, auid.to_s, suid.to_s + "-code" + get_file_extension(language))
        File.read(path)
    end
    def self.get_skeleton_code(iuid,cuid,auid,language)
        path = Rails.root.join("files", iuid.to_s, cuid.to_s, auid.to_s + "-skeleton_code" + get_file_extension(language))
        if (!File.exist?(path))
            return ""
        end
        File.read(path)
    end
end