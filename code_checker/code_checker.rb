require 'open3'
require 'tempfile'
require_relative '../fileIO/fileIO'
class CodeChecker
    SUCCESS = 0
    OUTPUT = 1
    def self.runCommand(cmd)
        #Runs command and returns if it is successful and stdout and stderr output
        result = []
        result, status = Open3.capture2e(cmd)
        success = (status == 0)
        return [success, result]
    end
    
    def self.testCode(language,suid,code)
        ext = FileIO::FileIO.get_file_extension(language)
        tempFileWithCode = Tempfile.new([suid,ext], :encoding => 'ASCII-8BIT')
        if (language == "Python")
            code = "# -*- coding: utf-8 -*-\n" + code
        end
        code = code.encode('ASCII', invalid: :replace, undef: :replace, replace: "")
        tempFileWithCode.write(code)
        tempFileWithCode.flush()
        return CodeChecker.runProgram(language, tempFileWithCode.path)
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
                @compile_result = runCommand(outFileName)
                runCommand("rm " + outFileName)
            end      
        else
            return false
        end
        #returns output of program as string
        if (@compile_result[SUCCESS])
            return "Compile Success!\nOutput:\n\n" + @compile_result[OUTPUT]
        else
            return "Compile Failure!\nTrace:\n\n" + @compile_result[OUTPUT]
        end
    end
end