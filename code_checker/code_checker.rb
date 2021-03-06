require 'open3'
require 'tempfile'
require 'tmpdir'
require_relative '../fileIO/fileIO'
class CodeChecker
    SUCCESS = 0
    OUTPUT = 1
    def self.runCommand(cmd, chroot=true)
        #Runs command and returns if it is successful and stdout and stderr output
        puts "Running command: " + cmd
        result = ""
        success = -1
        Open3.popen2e(cmd) { |input, output, wait_thr|
            begin
                Timeout.timeout(2) do
                until output.eof? do
                    result += output.read
                end
            end
            rescue Timeout::Error
                # process took longer than 10 seconds
                Process.kill("KILL", wait_thr.pid)
                result = "Program took too long to exit."
            end
            success = (wait_thr.value == 0)
        }
        return [success, result]
    end
    
    def self.testCode(language,suid,code)
        ext = FileIO.get_file_extension(language)
        puts "hi"
        tempFileWithCode = Tempfile.new([suid,ext], :encoding => 'ASCII-8BIT')
        code = code.encode('ASCII', invalid: :replace, undef: :replace, replace: "")
        tempFileWithCode.write(code)
        tempFileWithCode.flush()
        return CodeChecker.runProgram(language, tempFileWithCode.path)
    end

    def self.runProgram(language, filename)
        #Run command to compile and run input program based on language
        outFileName = ""
        if (language == "Python")
            @compile_result = runCommand("python " + filename)
        elsif (language == "Ruby")
            @compile_result = runCommand("ruby " + filename)
        elsif (language == "Java")
            @compile_result = runCommand("javac " + filename, false)
            if (@compile_result[SUCCESS])
                filename = filename.chomp(".java")
                @compile_result = runCommand("java " + filename)
            end
        elsif (language == "C++" || language == "C")
            if (language == "C++")
                outFileName = filename.chomp(".cpp") + ".out"
                @compile_result = runCommand("g++ " + filename + " -o " + outFileName,false)
            elsif (language == "C")
                outFileName = filename.chomp(".c") + ".out"
                @compile_result = runCommand("gcc " + filename + " -o " + outFileName, false)
            end
            if (@compile_result[SUCCESS])
                @compile_result = runCommand(outFileName)
            end      
        else
            runCommand("rm " + filename);
            return false
        end
        #returns output of program as string
        runCommand("rm " + filename);
        if (outFileName != "")
            runCommand("rm " + outFileName);
        end
        if (@compile_result[SUCCESS])
            return "Compile Success!\nOutput:\n\n" + @compile_result[OUTPUT]
        else
            return "Compile Failure!\nTrace:\n\n" + @compile_result[OUTPUT]
        end
    end
end
