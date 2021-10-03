import React from "react";

/**
 * Returns true if the task has a completed_at timestamp set, and false otherwise.
 * 
 * @param {*} task 
 */
function isComplete(task) {
    return task.completed_at != null;
}

/**
 * Sorts task for display. Incomplete tasks are listed first followed by
 * completed tasks.
 * 
 * @param {*} first The first task to compare.
 * @param {*} second The second task to compare.
 */
function taskSortOrder(first, second) {
    if (!isComplete(first) && isComplete(second)) {
        return -1;
    } else if (isComplete(first) && !isComplete(second)) {
        return 1;
    } else {
        return 0;
    }
}

function applyCsrfToken(config) {
    let csrfToken = document.head.querySelector("meta[name=csrf-token]");
    if (csrfToken != null) {
        // in test no CSRF token is required, and is not available in the document, so only
        // add it to the header if it is actually present.
        config['X-CSRF-Token'] = csrfToken.content;
    }
    return config;
}

const TaskList = () => {
    
    const [ tasks, setTasks ] = React.useState( [] );

    const onTaskCompletedStatusChange = React.useCallback((task) => {
        // if the task is currently not completed, then mark it as completed. otherwise
        // remove the mark of completion.
        const completedAt = !isComplete(task) ? new Date().toJSON() : null;

        fetch(task.url, {
            body: JSON.stringify({
                completed_at: completedAt
            }),
            credentials: "same-origin",
            method: "PATCH",
            headers: applyCsrfToken({ 'Content-Type': 'application/json' }),
            mode: "same-origin"
        }).then(response => {
            // create a copy to cause a re-render
            const updatedTasks = tasks.slice();
            if (response.status === 200) {
                // only update the task completed_at timestamp if the PATCH request was successful
                let updatedTask = updatedTasks.find(t => t.id === task.id);
                if (updatedTask != null) {
                    updatedTask.completed_at = completedAt;
                    updatedTasks.sort(taskSortOrder);
                }
            }
            setTasks(updatedTasks);
        }).catch(error => {
            console.error("Error updating task " + task.id + " completed status. " + error);
        });
    }, [tasks]);

    const onTaskDeleted = React.useCallback((task) => {
        const confirmed = confirm("Are you sure you want to delete this task?");
        if (!confirmed) {
            return;
        }
        
        fetch(task.url, {
            credentials: "same-origin",
            method: "DELETE",
            headers: applyCsrfToken({}),
            mode: "same-origin"
        }).then(response => {
            if (response.status === 200) {
                // remove the task if the delete was successful
                const updatedTasks = tasks.filter(t => t.id != task.id);
                setTasks(updatedTasks);
            }
        }).catch(error => {
            console.error("Error deleting task " + task.id + "." + error);
        });
    }, [tasks]);

    React.useEffect(() => {
        fetch("/tasks.json", {
            credentials: "same-origin",
            mode: "same-origin"
        }).then(response => {
            response.json().then(tasks => {
                tasks.sort(taskSortOrder);
                setTasks(tasks);
            });
        }).catch(error => {
            setTasks([]);
            console.error("Error fetching tasks list. " + error);
        });
    }, []);

    function showUrl(task) {
        if (task.url.endsWith(".json")) {
            // if the url ends with '.json' strip the last 5 characters
            return task.url.slice(0, -5);
        } else {
            return task.url;
        }
    }

    function editUrl(task) {
        return showUrl(task) + "/edit";
    }

    return (
        <table id="task-list">
            <thead>
                <tr>
                    <th>Task</th>
                    <th>Completed?</th>
                    <th colSpan="3">Actions</th>
                </tr>
            </thead>
            <tbody>
                {
                    tasks.map(task => 
                        <tr key={ task.id }>
                            <td>{ task.body }</td>
                            <td><input defaultChecked={ isComplete(task) } onChange={ () => onTaskCompletedStatusChange(task) } type="checkbox"/></td>
                            <td><a href={ showUrl(task) }>Show</a></td>
                            <td><a aria-disabled={ isComplete(task) } className={ isComplete(task) ? 'disabled' : '' } href={ editUrl(task) }>Edit</a></td>
                            <td><a aria-disabled={ isComplete(task) } className={ isComplete(task) ? 'disabled' : '' } href="" onClick={ () => onTaskDeleted(task) }>Delete</a></td>
                        </tr>
                    )                    
                }
            </tbody>
        </table>
    );
};

export default TaskList;
