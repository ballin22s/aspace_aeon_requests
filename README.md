# ArchivesSpace Aeon Requests plugin

Send requests from ArchivesSpace to Aeon.

Versions tested:

- 2.1.1

## Setup

For developers only:

- use a release copy of archivesspace for testing, not the source
- download this plugin using git to the `plugins` directory

Apply configuration in `config.rb`:

```
AppConfig[:plugins] << 'aspace_aeon_requests'
AppConfig[:aspace_aeon_requests_endpoint] = 'aeon.myinstitution.edu'

# you may want to edit these ArchivesSpace default settings:
AppConfig[:pui_requests_permitted_for_types] = [
  :resource,
  :archival_object,
  :accession,
  :digital_object,
  :digital_object_component
]
# set to 'true' if you want to disable if there is no top container
AppConfig[:pui_requests_permitted_for_containers_only] = false
```

## Request data

Without container (minimal):

```ruby
{
  :user_name=>"Mickey Mouse",
  :user_email=>"mickey.mouse@disney.com",
  :date=>"12/25/2017",
  :note=>"",
  :request_uri=>"/repositories/2/resources/1",
  :title=>"QQQ",
  :resource_name=>nil,
  :identifier=>"123",
  :cite=>"QQQ. TEST.   http://localhost:8081/repositories/2/resources/1  Accessed  September 07,
  2017.",
  :restrict=>nil,
  :hierarchy=>nil,
  :repo_name=>"TEST",
  :resource_id=>nil,
  :linked_record_uris=>nil,
  :machine=>nil,
  :top_container_url=>nil,
  :container=>nil,
  :barcode=>nil,
  :location_title=>nil,
  :location_url=>nil,
  :repo_uri=>"/repositories/2",
  :repo_code=>"TEST"
}
```

With container (and location):

```ruby
{
  :user_name=>"Mickey Mouse",
  :user_email=>"mickey.mouse@disney.com",
  :date=>"12/25/2017",
  :note=>"",
  :request_uri=>"/repositories/2/archival_objects/2",
  :title=>"B",
  :resource_name=>"QQQ",
  :identifier=>"",
  :cite=>"B. QQQ,
  . TEST.   http://localhost:8081/repositories/2/archival_objects/2  Accessed  September 07,
  2017.",
  :restrict=>nil,
  :hierarchy=>["QQQ", "A"],
  :repo_name=>"TEST",
  :resource_id=>"123",
  :linked_record_uris=>nil,
  :machine=>nil,
  :top_container_url=>["/repositories/2/top_containers/1"],
  :container=>["Box: 1 (Mixed Materials)"],
  :barcode=>["123456"],
  :location_title=>["Library, 1, Stacks, Y [Shelf: 1, Row: 2]"],
  :location_url=>["/locations/1"],
  :repo_uri=>"/repositories/2",
  :repo_code=>"TEST"
}
```

The request data is mapped to Aeon url parameters.

---