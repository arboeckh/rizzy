# Rizzy

A gem for parsing and writing .ris files

## Install
```bash
gem install rizzy
```
## Usage
### Parse a .ris file
```ruby
content = File.read("references.ris")
references = Rizzy.parse(content) # output is array of Rizzy::Reference struct
```
### Write a .ris file
```ruby
reference = Rizzy::Reference.new(type: "JOUR", database: "PubMed")  # add any fields available in the Rizzy::Reference struct
file_content = Rizzy.write(reference)  #accepts single reference or array of references
# write to file as needed
```
## TODO
- [ ] Implement non-common .ris tag types
