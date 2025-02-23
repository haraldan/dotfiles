function varargout = warning(varargin)
    fprintf('\033[33m');
    [varargout{1:nargout}] = builtin('warning',varargin{:});
    fprintf('\033[0m');
 end
