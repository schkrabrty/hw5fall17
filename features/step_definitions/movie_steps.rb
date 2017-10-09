# Completed step definitions for basic features: AddMovie, ViewDetails, EditMovie 

Given (/^I am on the RottenPotatoes home page$/) do
  visit movies_path
 end


 When (/^I have added a movie with title "(.*?)" and rating "(.*?)"$/) do |title, rating|
  visit new_movie_path
  fill_in 'Title', :with => title
  select rating, :from => 'Rating'
  click_button 'Save Changes'
 end

 Then (/^I should see a movie list entry with title "(.*?)" and rating "(.*?)"$/) do |title, rating| 
   result=false
   all("tr").each do |tr|
     if tr.has_content?(title) && tr.has_content?(rating)
       result = true
       break
     end
   end  
  expect(result).to be_truthy
 end

 When (/^I have visited the Details about "(.*?)" page$/) do |title|
   visit movies_path
   click_on "More about #{title}"
 end

 Then (/^(?:|I )should see "([^"]*)"$/) do |text|
    expect(page).to have_content(text)
 end

 When (/^I have edited the movie "(.*?)" to change the rating to "(.*?)"$/) do |movie, rating|
  click_on "Edit"
  select rating, :from => 'Rating'
  click_button 'Update Movie Info'
 end

# New step definitions to be completed for HW5. 
# Note that you may need to add additional step definitions beyond these


# Add a declarative step here for populating the DB with movies.

Given (/the following movies have been added to RottenPotatoes:/) do |movies_table|
  #pending  # Remove this statement when you finish implementing the test step
  movies_table.hashes.each do |movie|
    # Each returned movie will be a hash representing one row of the movies_table
    # The keys will be the table headers and the values will be the row contents.
    # Entries can be directly to the database with ActiveRecord methods
    # Add the necessary Active Record call(s) to populate the database.
    #movie = Hash[Movie.pluck('movies.title', 'movies.rating', 'movies.release_date')]
    Movie.create(movie)
  end
end

When (/^I have opted to see movies rated: "(.*?)"$/) do |arg1|
  # HINT: use String#split to split up the rating_list, then
  # iterate over the ratings and check/uncheck the ratings
  # using the appropriate Capybara command(s)
  visit movies_path
  a = arg1.split(/, /)
  
  uncheck('ratings_G')
  uncheck('ratings_PG')
  uncheck('ratings_PG-13')
  uncheck('ratings_NC-17')
  uncheck('ratings_R')
  
  a.each do |rating|
    check('ratings_'+rating)
  end
  
  click_button 'Refresh'
  #pending  #remove this statement after implementing the test step
end

Then (/^I should see only movies rated: "(.*?)"$/) do |arg1|
  a = arg1.split(/, /)
  #puts a
  b = Movie.where(:rating => a).count
  #puts b
  rows = page.all('#movies tr').size - 1 #(The header of the table will be discarded)
  #puts rows
  rows.should == b
end


Then (/^I should see all of the movies$/) do 
  b = Movie.count
  #puts b
  rows = page.all('#movies tr').size - 1  #(The header of the table will be discarded)
  #puts rows
  rows.should == b
end

When (/^I click on Movie Title Link$/) do
    visit movies_path
    click_on "Movie Title"
end

Then (/^I should see "(.*?)" before "(.*?)"$/) do |arg1, arg2|
    result = false
    a = 0
    b = 0
    count = 0
    page.all('#movies tr > td:nth-child(1)').each do |td|
        if td.text == arg1
            a = count
        end
        if td.text == arg2
            b = count
        end
        count += 1
    end
    #puts a
    #puts b
    if a < b
        result = true
    end
    expect(result).to be_truthy
end

When (/^I click on Release Date Link$/) do
    #visit movies_path
    click_on "Release Date"
end

Then (/^I should see the release date "(.*?)" before "(.*?)"$/) do |arg1, arg2|
    result = false
    a = 0
    b = 0
    count = 0
    page.all('#movies tr > td:nth-child(3)').each do |td|
        if td.text == arg1
            a = count
        end
        if td.text == arg2
            b = count
        end
        count += 1
    end
    #puts a
    #puts b
    if a < b
        result = true
    end
    expect(result).to be_truthy
end

