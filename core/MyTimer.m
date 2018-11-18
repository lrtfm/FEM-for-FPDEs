classdef MyTimer < handle
   properties (Access = private)
      msg
      step
      last
      count
      extra
      tbegin
      handle
   end
   methods
       function obj = MyTimer(last, step, msg, logfile)
           obj.msg = msg;
           obj.step = step;
           obj.last = last;
           obj.count = 0;
           if numlabs > 1
               obj.extra = 2;
           else
               obj.extra = 0;
           end
           if nargin < 4
               obj.handle = -1;
           else
               obj.handle = fopen(logfile, 'a');
           end
       end
       
       function obj = beginwatch(obj)
           s = sprintf('%s Begin(%g).', obj.msg, obj.last);
           fprintf(1, s);
           obj.tbegin = tic;
           if obj.handle ~= -1
               fprintf(obj.handle, [s '\n']);
           end
       end
       
       function  obj = watch(obj, k)
           if mod(k, obj.step) == 0
               tused = toc(obj.tbegin);
               str = sprintf('\tk = %6d, remain time: %s, used time: %s',...
                   k, calendarDuration(0, 0, 0, 0, 0, tused/k*(obj.last-k)),...
                      calendarDuration(0, 0, 0, 0, 0, tused));
               s =  strcat(char(kron(ones(1, obj.count), '\b')), str, '\n');
               obj.count = fprintf(1, s)  - obj.count + obj.extra;
               if obj.handle ~= -1
                   fprintf(obj.handle, '%s\n', str);
               end
           end
       end
       function obj = printf(obj, fmt, varargin)
           argstr = '';
           if nargin > 2
               for i = 1:(nargin - 2)
                argstr = strcat(argstr, ',varargin{', num2str(i), '}'); 
               end
           end
           str = strcat('fprintf(1,''', fmt , '''', argstr, ');');
           if obj.count > obj.extra
               obj.count = obj.count - obj.extra;
           end
           fprintf(1, char(kron(ones(1, obj.count), '\b')));
           eval(str);
           if obj.handle ~= -1
               str = strcat('fprintf(obj.handle, fmt', argstr, ');');
           	   eval(str);
           end
           obj.count = 0;
       end

       function obj = endwatch(obj)
           tused = toc(obj.tbegin);
           str = sprintf('End. Used time: %s', calendarDuration(0, 0, 0, 0, 0, tused));
           s = strcat(char(kron(ones(1, obj.count), '\b')), str, '\n');
           fprintf(1, s);
           if obj.handle ~= -1
               fprintf(obj.handle, '%s %s\n', obj.msg, str);
           end
       end
       function delete(obj)
           % fprintf(1, 'Bye friends, I am gone!!! You know why!!!\n');
           if obj.handle ~= -1
               % fprintf(obj.handle, 'Bye friends, I am gone!!! You know why!!!\n');
               fclose(obj.handle);
           end
       end
   end
end