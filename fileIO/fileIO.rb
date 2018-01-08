require 'fileutils'
#skeleton code, logs, and submissions
class FileIO
    def write_log(iuid,cuid,auid,suid,input)
        File.write("#{iuid}/#{cuid}/#{auid}/#{suid}/-log.txt", "#{input}")
    end
    def write_code(iuid,cuid,auid,suid,input)
        File.write("#{iuid}/#{cuid}/#{auid}/#{suid}/-code.txt", "#{input}")
    end
    def write_skeleton_code(iuid,cuid,auid,input)
        File.write("#{iuid}/#{cuid}/#{auid}/-skeleton_code.txt", "#{input}")
    end
    
    def read_log(iuid,cuid,auid,suid)
        File.read("#{iuid}/#{cuid}/#{auid}/#{suid}/-log.txt")
    end
    def read_code(iuid,cuid,auid,suid)
        File.read("#{iuid}/#{cuid}/#{auid}/#{suid}/-code.txt")
    end
    def get_skeleton_code(iuid,cuid,auid)
        if (File.exist?("#{iuid}/#{cuid}/#{auid}/-skeleton_code.txt"))
            return ""
        end
        File.read("#{iuid}/#{cuid}/#{auid}/-skeleton_code.txt")
    end
end