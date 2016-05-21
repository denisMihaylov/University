import re


def critic(code, **rules):

    result = {}
    line_length = rules.get('line_length', 79)  # check ok
    forbid_semicolons = rules.get('forbid_semicolons', True)  # check ok
    max_nesting = rules.get('max_nesting', None)  # check ok
    indentation_size = rules.get('indentation_size', 4)  # check ok
    max_methods = rules.get('methods_per_class', None)
    max_arity = rules.get('max_arity', None)   # check ok
    # check ok
    trailing_whitespace = rules.get('forbid_trailing_whitespace', True)
    max_lines = rules.get('max_lines_per_function', None)  # check
    nest = 0
    lines = code.splitlines()
    scope_start = []
    function_nest = []
    class_line = 0
    class_methods = 0
    class_nest = None

    for line_number, line in enumerate(lines):
        line_number += 1
        result[line_number] = []
        critics = result[line_number]
        check_line_length(line, critics, line_length)
        check_forbid_semicolons(line, critics, forbid_semicolons)
        last_indent = check_indent(line, critics, nest, indentation_size)
        if last_indent:
            nest -= 1
            if nest == class_nest:
                class_res = result[class_line]
                check_class(class_line, class_methods, max_methods, class_res)
        check_nesting(line, critics, nest, max_nesting)
        check_whitespace(line, critics, trailing_whitespace)
        is_def = check_max_arity(line, critics, max_arity)
        if is_def:
            scope_start.append(line_number)
            class_methods += 1
            function_nest.append(nest)
        elif len(function_nest) > 0 and nest == function_nest[-1]:
            start = scope_start.pop()
            check_lines_per_function(start, line_number, result, max_lines)
            class_nest = None
        if (line.rstrip().endswith(':')):
            if re.match('\s*class.*\\((.*)\\)\s*:\s*\Z', line):
                class_nest = nest
                class_line = line_number
                class_methods = 0
            nest += 1
    if len(scope_start) > 0:
        start = scope_start.pop()
        check_lines_per_function(start, line_number, result, max_lines)
    if class_nest is not None:
        check_class(class_line, class_methods, max_methods, result[class_line])
    return {key: value for (key, value) in result.items() if (len(value) != 0)}


def check_line_length(line, result, line_length):
    if len(line) > line_length:
        result.append("line too long (%s > %s)" % (len(line), line_length))


def check_forbid_semicolons(line, result, forbid_semicolons):
    if forbid_semicolons:
        double_quote = re.match('([^"\\\']*"[^"\\\']*")*[^"\\\']*;', line)
        single_quote = re.match("([^'\\\"]*'[^'\\\"]*')*[^'\\\"]*;", line)
        if double_quote or single_quote:
            result.append("multiple expressions on the same line")


def check_indent(line, result, nest, indentation_size):
    indent = len(re.match('\s*', line).group(0))
    current_indent = nest * indentation_size
    is_current_indent = current_indent == indent
    is_last_indent = current_indent - indentation_size == indent
    if not (is_current_indent or is_last_indent):
        message = "indentation is %s instead of %s" % (indent, current_indent)
        result.append(message)
    return is_last_indent


def check_nesting(line, result, nest, max_nesting):
    if max_nesting and nest > max_nesting:
        result.append("nesting too deep (%s > %s)" % (nest, max_nesting))


def check_whitespace(line, result, trailing_whitespace):
    has_trailing = len(re.search('\S*(\s*)\Z', line).group(1)) is not 0
    if trailing_whitespace and has_trailing:
        result.append("trailing whitespace")


def check_max_arity(line, result, max_arity):
    match = re.match('\s*def.*\\((.*)\\)\s*:\s*\Z', line)
    is_def = match
    if max_arity:
        if not match:
            match = re.match('\s*lambda\s*(.*):', line)
        count = len(re.findall('[^,]+', match.group(1))) if match else 0
        if count > max_arity:
            message = "too many arguments(%s > %s)" % (count, max_arity)
            result.append(message)
    return is_def


def check_lines_per_function(start, end, result, max_lines):
    method_lines = end - start
    if max_lines and method_lines > max_lines:
        message = ("method with too"
                   " many lines (%s > %s)") % (method_lines, max_lines)
        result[start].append(message)


def check_class(class_line, count, max_methods, result):
    if (count > max_methods):
        message = "too many methods in class(%s > %s)" % (count, max_methods)
        result.append(message)
