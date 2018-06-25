classdef Point < handle
    
    properties
        Name, Tags, Fields, Time;
    end
    
    methods
        % Constructor
        function obj = Point(name)
            obj.Name = name;
            obj.Tags = {};
            obj.Fields = {};
            obj.Time = [];
        end
        
        % Add a tag
        function obj = tag(obj, key, value)
            obj.Tags{end + 1} = [key '=' value];
        end
        
        % Add multiple tags at once
        function obj = tags(obj, varargin)
            forEachPair(varargin, @(k, v) obj.tag(k, v));
        end
        
        % Add a field value
        function obj = field(obj, key, value)
            if isnumeric(value)
                obj.Fields{end + 1} = [key '=' num2str(value)];
            elseif ischar(value)
                obj.Fields{end + 1} = [key '="' value '"'];
            else
                error('unsupported value type');
            end
        end
        
        % Add multiple fields at once
        function obj = fields(obj, varargin)
            forEachPair(varargin, @(k, v) obj.field(k, v));
        end
        
        % Set the time
        function obj = time(obj, time)
            if isdatetime(time)
                obj.Time = num2str(int64(1000 * posixtime(time)));
            elseif isfloat(time)
                warning('timezone not specified, assuming local');
                dtime = datetime(time, 'ConvertFrom', 'datenum', 'TimeZone', 'local');
                obj.Time = num2str(int64(1000 * posixtime(dtime)));
            else
                error('unsupported time type');
            end
        end
        
        % Format to Line Protocol
        function line = toLine(obj)
            assert(~isempty(obj.Name), 'toLine:emptyName', 'series name cannot be empty');
            assert(~isempty(obj.Fields), 'toLine:emptyFields', 'must define at least one field');
            start = strjoin([{obj.Name}, obj.Tags], ',');
            fields = strjoin(obj.Fields, ',');
            if isempty(obj.Time)
                line = [start, ' ', fields];
            else
                line = [start, ' ', fields, ' ', obj.Time];
            end
        end
    end
    
end
