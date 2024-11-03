import re
from terraform_compliance.steps import step

@step(r'Given I have azure_resource_group')
def given_i_have_azure_resource_group(step):
    """
    Custom step to focus only on Azure resource groups.
    """
    # Filter for resources of type 'azurerm_resource_group'
    step.context['resources'] = [
        res for res in step.context['resources'] if res['type'] == 'azurerm_resource_group'
    ]

@step(r'Then its name must match the "(?P<pattern>.*)" regex')
def name_must_match_regex(step, pattern):
    """
    Custom step to check if a resource's name matches a specified regex pattern.
    """
    for resource in step.context['resources']:
        resource_name = resource.get('values', {}).get('name', '')
        if not re.match(pattern, resource_name):
            step.context['output'].add_error(
                f"Resource '{resource['address']}' name '{resource_name}' does not match the regex '{pattern}'."
            )

@step(r'Then it must have tags')
def must_have_tags(step):
    """
    Custom step to ensure each resource has tags.
    """
    for resource in step.context['resources']:
        if 'tags' not in resource.get('values', {}):
            step.context['output'].add_error(
                f"Resource '{resource['address']}' does not have any tags."
            )
