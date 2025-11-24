# Contributing Guidelines

This document provides guidelines for instructors and contributors to maintain consistency when adding materials to this repository.

## Adding Lecture Materials

When adding materials to the `lectures/` folder:

1. **Naming Convention:**
   - Slides: `weekXX_topic.pdf` or `weekXX_topic.pptx`
   - Code examples: `weekXX_example_description.R`
   - Notes: `weekXX_notes.pdf`

2. **Location:**
   - Place all materials in the appropriate `weekXX/` folder
   - Keep related materials together

3. **Documentation:**
   - Add a brief README in the week folder if there are multiple files
   - Include the date and topic covered

## Adding Laboratory Materials

When adding materials to the `labs/` folder:

1. **Naming Convention:**
   - Exercises: `labXX_exercises.R`
   - Instructions: `labXX_instructions.pdf` (optional)
   - Additional files: `labXX_description.ext`

2. **Structure of R Scripts:**
   - Use the template provided in `labs/lab_template.R`
   - Include clear objectives at the top
   - Provide detailed comments and instructions
   - Leave space for students to add their code

3. **Solutions:**
   - Place solutions in the `/solutions` folder
   - Name: `labXX_solution.R`
   - Include detailed comments explaining the approach
   - Show interpretation of results

## Adding Datasets

When adding datasets to the `data/` folder:

1. **Raw Data:**
   - Place original files in `data/raw/`
   - Do not modify raw data files
   - Include source information

2. **Processed Data:**
   - Save cleaned data in `data/processed/`
   - Document preprocessing steps
   - Use descriptive filenames

3. **Documentation:**
   - Create a data dictionary explaining variables
   - Can be a separate text file or README
   - Include: variable names, types, units, time period

4. **Format:**
   - Prefer CSV for tabular data
   - Use RDS for R objects (efficient storage)
   - Compress large files if necessary

## Adding Reference Materials

When adding materials to the `references/` folder:

1. **Organization:**
   - Consider organizing by topic or type
   - Use clear, descriptive filenames

2. **Copyright:**
   - Only include materials you have permission to share
   - For copyrighted materials, provide links instead

3. **Documentation:**
   - Add a brief description in the main `references/README.md`
   - Include citation information

## Adding Project Materials

When adding materials to the `project/` folder:

1. **Guidelines:**
   - Project instructions and requirements
   - Deliverable specifications
   - Submission deadlines and format

2. **Templates:**
   - R Markdown templates for project reports
   - R script templates with standard structure
   - Example projects (anonymized if needed)

3. **Data:**
   - Project-specific datasets
   - Data dictionaries for project data
   - Links to external data sources

4. **Rubrics:**
   - Grading criteria and evaluation rubrics
   - Assessment guidelines
   - Examples of excellent work

## Git Workflow

1. **Before Adding Files:**
   ```bash
   git pull origin main  # Update your local copy
   ```

2. **Adding New Materials:**
   ```bash
   git add [specific files]
   git commit -m "Add: descriptive message"
   git push origin main
   ```

3. **Commit Messages:**
   - Use clear, descriptive messages
   - Start with a verb: Add, Update, Fix, Remove
   - Examples:
     - "Add: Week 3 lecture slides on VAR models"
     - "Update: Lab 2 with additional exercises"
     - "Fix: Typo in lab 1 instructions"

## File Size Considerations

- **Large files (>10 MB):** Consider using Git LFS or external hosting
- **Datasets:** Compress if possible, or provide download links
- **Videos:** Always host externally and provide links

## Code Quality

### R Scripts

- Use consistent indentation (2 or 4 spaces)
- Include comments for complex operations
- Follow R style guides (e.g., Tidyverse style guide)
- Test code before committing
- Use meaningful variable names

### Example:
```r
# Good
mean_gdp <- mean(gdp_data$value, na.rm = TRUE)

# Avoid
m <- mean(x, na.rm = TRUE)
```

## Questions or Issues?

If you're unsure about where to place a file or how to structure content:
1. Check existing examples in the repository
2. Refer to the README files in each folder
3. Contact the course coordinator
4. Open an issue for discussion

## Maintenance

- Regularly review and update materials
- Remove outdated content
- Keep README files current
- Respond to issues and questions promptly
