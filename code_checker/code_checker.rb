require 'open3'
require 'tempfile'
require_relative '../fileIO/fileIO'
class CodeChecker
    SUCCESS = 0
    STDOUT = 1
    STDERR = 2
    def self.runCommand(cmd)
        #Runs command and returns if it is successful and stdout and stderr output
        result = []
        Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
            puts stderr.read
            result = [wait_thr.value.success?, stdout.read, stderr.read]
        end
        puts result
        return result
    end
    
    def self.testCode(language,suid,code)
        ext = FileIO.get_file_extension(language)
        tempFileWithCode = Tempfile.new([suid,ext])
        tempFileWithCode.write(code)
        return CodeChecker.runProgram(language,tempFileWithCode.path)
    end

    def self.runProgram(language, filename)
        #Run command to compile and run input program based on language
        if (language == "Python")
            @compile_result = runCommand("python " + filename)
        elsif (language == "Ruby")
            @compile_result = runCommand("ruby " + filename)
        elsif (language == "Java")
            @compile_result = runCommand("javac " + filename)
            if (@compile_result[SUCCESS])
                filename = filename.chomp(".java")
                @compile_result = runCommand("java " + filename)
                runCommand("rm " + filename + ".class")
            end
        elsif (language == "C++" || language == "C")
            if (language == "C++")
                outFileName = filename.chomp(".cpp") + ".out"
                @compile_result = runCommand("g++ " + filename + " -o " + outFileName)
            elsif (language == "C")
                outFileName = filename.chomp(".c") + ".out"
                @compile_result = runCommand("gcc " + filename + " -o " + outFileName)
            end
            if (@compile_result[SUCCESS])
                @compile_result = runCommand("./" + outFileName)
                runCommand("rm " + outFileName)
            end      
        else
            return false
        end
        #returns output of program as string
        if (@compile_result[SUCCESS])
            return "Compile Success!\nOutput:\n\n" + @compile_result[STDOUT]
        else
            return "Compile Failure!\nTrace:\n\n" + @compile_result[STDERR]
        end
    end
end