require 'fileutils'
#skeleton code, logs, and submissions
class FileIO
    def self.write_log(iuid,cuid,auid,suid,input)
        path = Rails.root.join("files", iuid.to_s, cuid.to_s, auid.to_s)
        FileUtils.makedirs(path)
        path = File.join(path.to_s, suid.to_s + "-log")
        File.write(path, input)
    end
    def self.write_code(iuid,cuid,auid,suid,input)
        path = Rails.root.join("files", iuid.to_s, cuid.to_s, auid.to_s)
        FileUtils.makedirs(path)
        path = File.join(path.to_s, suid.to_s + "-code")
        File.write(path, input)
    end
    def self.write_skeleton_code(iuid,cuid,auid,input)
        path = Rails.root.join("files", iuid.to_s, cuid.to_s)
        FileUtils.makedirs(path)
        path = File.join(path.to_s, auid.to_s + "-skeleton_code")
        File.write(path, input)
        puts "wrote to " + path.to_s
    end
    
    def self.read_log(iuid,cuid,auid,suid)
        path = Rails.root.join("files", iuid.to_s, cuid.to_s, auid.to_s, suid.to_s + "-log")
        File.read(path)
    end
    def self.read_code(iuid,cuid,auid,suid)
        path = Rails.root.join("files", iuid.to_s, cuid.to_s, auid.to_s, suid.to_s + "-code")
        File.read(path)
    end
    def self.get_skeleton_code(iuid,cuid,auid)
        path = Rails.root.join("files", iuid.to_s, cuid.to_s, auid.to_s + "-skeleton_code")
        if (!File.exist?(path))
            return ""
        end
        File.read(path)
    end
end