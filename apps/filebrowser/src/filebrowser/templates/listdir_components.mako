## Licensed to Cloudera, Inc. under one
## or more contributor license agreements.  See the NOTICE file
## distributed with this work for additional information
## regarding copyright ownership.  Cloudera, Inc. licenses this file
## to you under the Apache License, Version 2.0 (the
## "License"); you may not use this file except in compliance
## with the License.  You may obtain a copy of the License at
##
##     http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
<%!
import datetime
from django.template.defaultfilters import urlencode, stringformat, filesizeformat, date, time
from desktop.lib.django_util import reverse_with_get
%>


<%def name="list_table_chooser(files, path, current_request_path)">
  ${_table(files, path, current_request_path, 'chooser')}
</%def>
<%def name="list_table_browser(files, path, current_request_path, cwd_set=True)">
  ${_table(files, path, current_request_path, 'view', cwd_set)}
</%def>
<%def name="_table(files, path, current_request_path, view, cwd_set=False)">
  <%
  # Sortable takes a while for big lists; skip it in that case.
  if len(files) < 100:
    optional_sortable = "sortable"
  else:
    optional_sortable = ""
  # FitText doesn't scale well with many rows, so we disable it for
  # larger views.
  if len(files) < 30:
    optional_fit_text = 'data-filters="FitText"'
  else:
    optional_fit_text = ''
  %>
  <table data-filters="HtmlTable"class="zebra-striped">
    <thead>
      <tr>
        % if cwd_set:
          <th>Name</th>
        % else:
          <th>Path</th>
        % endif
        <th>Size</th>
        <th>User</th>
        <th>Group</th>
        <th>Permissions</th>
        <th colspan="2">Date</th>
      </tr>
    </thead>
    <tbody>
      % for file in files:
        <%
          cls = ''
          if (file_filter == 'dir' and file['type'] != 'dir') or (file_filter != 'dir' and file['type'] == 'dir'):
            if (file_filter != 'any'):
              cls = ' not-selectable'

          if cwd_set:
            display_name = file['name']
          else:
            display_name = file['path']
          endif
        %>
  ## Since path is in unicode, Django and Mako handle url encoding and
  ## iri encoding correctly for us.
        <% path = file['path'] %>
        <tr>
          <td>
            <div>
              % if "dir" == file['type']:
                <h3><a ${optional_fit_text | n} href="${url('filebrowser.views.'+view, path=urlencode(path))}?file_filter=${file_filter}">${display_name}</a></h3>
              % else:
                <h3><a ${optional_fit_text | n} href="${url('filebrowser.views.'+view, path=urlencode(path))}?file_filter=${file_filter}">${display_name}</a></h3>
              % endif

            </div>
          </td>
          <%
            if "dir" == file['type']:
              sortValue = 0;
            else:
              sortValue = file['stats']['size']
          %>
          <td>
            % if "dir" == file['type']:
              <span>~</span>
            % else:
              <span>${file['stats']['size']|filesizeformat}</span>
            % endif
          </td>
          <td>${file['stats']['user']}</td>
          <td>${file['stats']['group']}</td>
          <td>${file['rwx']}</td>
          <td><span>${date(datetime.datetime.fromtimestamp(file['stats']['mtime']))} ${time(datetime.datetime.fromtimestamp(file['stats']['mtime']))}</span></td>
          <td>
             % if ".." != file['name']:

                  % if "dir" == file['type']:
                    <a class="fb-rmdir confirm_unencode_and_post btn danger small" alt="Are you sure you want to delete this directory and its contents?" href="${reverse_with_get('filebrowser.views.rmdir', get=dict(path=path,next=current_request_path))}">Delete</a></li>
                    <a class="fb-rmtree confirm_unencode_and_post fb-default-rm btn danger small" alt="Are you sure you want to delete ${display_name} and its contents?" href="${reverse_with_get('filebrowser.views.rmtree', get=dict(path=path,next=current_request_path))}"">Delete</a>
                  % else:
                    <a class="fb-viewfile btn small" href="${url('filebrowser.views.view', path=urlencode(path))}">View File</a>
                    <a class="fb-editfile btn small" href="${url('filebrowser.views.edit', path=urlencode(path))}">Edit File</a>
                    <a class="fb-downloadfile btn small" href="${url('filebrowser.views.download', path=urlencode(path))}" target="_blank">Download File</a>
                    <a class="fb-rm fb-default-rm confirm_unencode_and_post btn small" alt="Are you sure you want to delete ${display_name}?" href="${reverse_with_get('filebrowser.views.remove', get=dict(path=path, next=current_request_path))}">Delete</a>
                  % endif
                  <a class="fb-rename btn small" href="${reverse_with_get('filebrowser.views.rename',get=dict(src_path=path,next=current_request_path))}">Rename</a>
                  <a class="fb-chown btn small" href="${reverse_with_get('filebrowser.views.chown',get=dict(path=path,user=file['stats']['user'],group=file['stats']['group'],next=current_request_path))}">Change Owner / Group</a>
                  <a class="fb-chmod btn small" href="${reverse_with_get('filebrowser.views.chmod',get=dict(path=path,mode=stringformat(file['stats']['mode'], "o"),next=current_request_path))}">Change Permissions</a>
                  <%
                    if "dir" == file['type']:
                      cls = "fb-move-dir"
                    else:
                      cls = "fb-move-file"
                  %>
                  <a class="fb-move ${cls} btn small" href="${reverse_with_get('filebrowser.views.move',get=dict(src_path=path,mode=stringformat(file['stats']['mode'], "o"),next=current_request_path))}">Move</a>

              % endif
          </td>
        </tr>
      % endfor
    </tbody>
  </table>
</%def>
